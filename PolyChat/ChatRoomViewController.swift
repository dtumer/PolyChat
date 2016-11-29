//
//  ChatRoomViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 8/17/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftKeychainWrapper
import CryptoSwift
import OneSignal

class ChatRoomViewController: JSQMessagesViewController {

    // Services
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    var messageService: MessageServiceProtocol!
    var chatroomsUsersService: ChatRoomsUsersServiceProtocol!
    
    // Current user
    var user: User!
    
    // Chat room object
    var chatRoom: ChatRoom!
    
    //course reference
    var course: Course!
    
    // Messages in the chat room
    var messages = [JSQMessage]()
    
    // Two types of message bubbles
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    //app cert
    let appCert: [UInt8] = GlobalUtilities.hexToByteArray(KeychainWrapper.standard.string(forKey: Constants.APP_CERT_KEY)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        initNavigation()
        setupBubbles()
        setupAvatarViewSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        }
        else {
            //get logged in user information
            authService.getCurrentUser({ user, error in
                if let user = user {
                    self.user = user
                    self.senderId = user.id
                    self.senderDisplayName = user.name
                    self.loadMessages()
                } else if let error = error {
                    print(error)
                }
            })
        }
        
    }
    
    //initializes services needed
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.userService = UserServiceFactory.sharedInstance
        self.messageService = MessageServiceFactory.sharedInstance
        self.chatroomsUsersService = ChatRoomsUsersServiceFactory.sharedInstance
    }

    //initializes navigation bar
    fileprivate func initNavigation() {
        //sets title to chat room name
        self.navigationItem.title = chatRoom.name
        
        //sets right bar button item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "InfoIcon"), style: .plain, target: self, action: #selector(ChatRoomViewController.chatInfo))
    }
    
    func chatInfo() {
        self.performSegue(withIdentifier: Constants.chatDetailSegueId, sender: self)
    }
    
    // Sets up the message bubbles
    fileprivate func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    fileprivate func setupAvatarViewSize() {
        // TODO: add support for avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    }
    
    func loadMessages() {
        //init chat rooms
        self.messages = []
        
        messageService.getMessagesInChatRoom(chatRoom.id, callback: { (messages, error) in
            if let messages = messages {
                for message in messages {
                    do {
                        let iv = GlobalUtilities.hexToByteArray(message.stamp)
                        let body = try String(data: Data(AES(key: self.appCert, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(GlobalUtilities.hexToByteArray(message.body))), encoding: String.Encoding.utf8)
                        let msg = JSQMessage(senderId: message.senderId, senderDisplayName: message.senderName,
                            date: Date(timeIntervalSince1970: message.messageSent), text: body)
                        self.messages.append(msg!)
                        self.finishReceivingMessage()
                    }
                    catch {
                        print(error)
                    }
                }
            }
            else {
                //TODO report error
            }
        })
    }
    
    func addMessage(_ text: String) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message!)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        do {
            let iv = AES.randomIV(AES.blockSize)
            let stamp = Data(iv).toHexString()
            let body = try Data(AES(key: self.appCert, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(text.utf8.map({$0}))).toHexString()
            let message = Message(dictionary:[
                "body": body,
                "sender_id": senderId,
                "sender_name": senderDisplayName,
                "stamp": stamp
                ])
            messageService.addMessageToChatRoom(chatRoom.id, message: message, callback: { error in
                if let error = error {
                    print(error)
                } else {
                    JSQSystemSoundPlayer.jsq_playMessageSentSound()
                    self.finishSendingMessage()
                    self.collectionView.reloadData()
                }
            })

        }
        catch {
            print(error)
        }
        sendNotification(text)
    }
    
    fileprivate func sendNotification(_ message: String) {
        var notifyIds = [String]() // Array to hold all notifyIds we will need

        /* Get all users in chatroom and grab all of their notifyIds, if available */
        chatroomsUsersService.getUserReferences(chatRoomId: self.chatRoom.id, callback: { (users, error) in
            if error != nil {
                print(error!)
            } else if users != nil {
                for user in users! {
                    if (!user.notifyId.isEmpty) {
                        notifyIds.append(user.notifyId)
                    }
                }
                OneSignal.postNotification([
                    "contents": ["en": "\(self.senderDisplayName!): \(message)"],
                    //"headings": ["en": "*Title*"],
                    "subtitle": ["en": self.chatRoom.name],
                    "include_player_ids": notifyIds
                ], onSuccess: { result in
                    print("SUCCESS!")
                }, onFailure: { error in
                    print("FAILURE!")
                })
            }
        })
    }
    
    //prepare for segue override for chat details
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if we're looking at the chat details
        if segue.identifier == Constants.chatDetailSegueId {
            if let vc = segue.destination as? ChatDetailsViewController {
                vc.chatRoom = self.chatRoom
                vc.course = self.course
                
                //setup back button
                let back = UIBarButtonItem()
                back.title = "Back"
                
                self.navigationItem.backBarButtonItem = back
            }
        }
    }
}

// Delegate/DataSource Methods
extension ChatRoomViewController {
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        // TODO: this checks who the message is sent by and returns the correct message bubble
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.white
        } else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    // For the display name of messages
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        guard let senderDisplayName = message.senderDisplayName else {
            assertionFailure()
            return nil
        }
        return NSAttributedString(string: senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return 13 //or what ever height you want to give
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        // TODO: Add support for avatars here
        return nil
    }
    
}
