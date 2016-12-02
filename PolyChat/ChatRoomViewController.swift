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
    
    //keep track of the total amount of messages loaded in the chat
    var totalMessages: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        initNavigation()
        setupBubbles()
        setupAvatarViewSize()
        setupInputToolbar()
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
                    self.loadMessages(last: Constants.LOAD_MESSAGES_DEFAULT)
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
    
    fileprivate func setupInputToolbar() {
        // Remove the attachment button
        self.inputToolbar.contentView.leftBarButtonItem = nil
    }
    
    func loadMessages(last n: Int) {
        //init chat rooms
        self.messages = []
        self.showLoadEarlierMessagesHeader = true
        
        messageService.getMessagesInChatRoom(chatRoom.id, last: n, callback: { (message, error) in
            if let msg = message {
                do {
                    let iv = GlobalUtilities.hexToByteArray(msg.stamp)
                    let body = try String(data: Data(AES(key: self.appCert, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(GlobalUtilities.hexToByteArray(msg.body))), encoding: String.Encoding.utf8)
                    let msg = JSQMessage(senderId: msg.senderId, senderDisplayName: msg.senderName,
                        date: Date(timeIntervalSince1970: msg.messageSent), text: body)
                    self.messages.append(msg!)
                    self.finishReceivingMessage()
                }
                catch {
                    print(error)
                }
                self.totalMessages = self.messages.count
            }
            else if let error = error {
                print(error)
            }
        })
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
                    self.sendNotification(text)
                }
            })

        }
        catch {
            print(error)
        }
    }
    
    fileprivate func sendNotification(_ message: String) {
        var notifyIds = [String]() // Array to hold all notifyIds we will need

        /* Get all users in chatroom and grab all of their notifyIds, if available */
        chatroomsUsersService.getUserReferences(chatRoomId: self.chatRoom.id, callback: { (users, error) in
            if error != nil {
                print(error!)
            } else if users != nil {
                for user in users! {
                    if (user.notifications && !user.notifyId.isEmpty) { //add this when done dev testing: && self.user.notifyId != user.notifyId) {
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
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, header headerView: JSQMessagesLoadEarlierHeaderView!, didTapLoadEarlierMessagesButton sender: UIButton!) {
        self.automaticallyScrollsToMostRecentMessage = false
        loadMessages(last: totalMessages + Constants.LOAD_MESSAGES_DEFAULT)
    }
    
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
    
    // For displaying timestamp
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        
        if (indexPath.item == 0) {
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        else if (indexPath.item - 1 > 0) {
            let prevMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSince(prevMessage.date) - Constants.TIMESTAMP_INTERVAL > 0 {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            }
            
        }
        return nil
    }
    
    // height of timestamp
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if indexPath.item == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        else if indexPath.item - 1 > 0 {
            let message = messages[indexPath.item]
            let prevMessage = messages[indexPath.item - 1]
            if message.date.timeIntervalSince(prevMessage.date) - Constants.TIMESTAMP_INTERVAL > 0 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        return 0
    }

    // For the display name of messages
    override func collectionView(_ collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        if (indexPath.item == 0) {
            return NSAttributedString(string: message.senderDisplayName)
        }
        
        // Display name if the previous message wasn't sent by the same person
        // Also display name no matter what if it has been more that TIMESTAMP_INTERVAL since the last message was sent in the chat
        else if (indexPath.item - 1 > 0) {
            let prevMessage = messages[indexPath.item - 1]
            if message.senderId != prevMessage.senderId || message.date.timeIntervalSince(prevMessage.date) - Constants.TIMESTAMP_INTERVAL > 0 {
                return NSAttributedString(string: message.senderDisplayName)
            }
        }
        
        return nil
    }
    
    // height of display names for messages
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        if (indexPath.item == 0) {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        else if (indexPath.item - 1 > 0) {
            let message = messages[indexPath.item]
            let prevMessage = messages[indexPath.item - 1]
            if message.senderId != prevMessage.senderId || message.date.timeIntervalSince(prevMessage.date) - Constants.TIMESTAMP_INTERVAL > 0 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
        }
        
        return 0
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
}
