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

class ChatRoomViewController: JSQMessagesViewController {

    // Services
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    var messageService: MessageServiceProtocol!
    
    // Current user
    var user: User!
    
    // Chat room object
    var chatRoom: ChatRoom!
    
    // Messages in the chat room
    var messages = [JSQMessage]()
    
    // Two types of message bubbles
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    //app cert
    let appCert: [UInt8] = GlobalUtilities.hexToByteArray(KeychainWrapper.defaultKeychainWrapper().stringForKey(Constants.APP_CERT_KEY)!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        initNavigation()
        setupBubbles()
        setupAvatarViewSize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
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
    private func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.userService = UserServiceFactory.sharedInstance
        self.messageService = MessageServiceFactory.sharedInstance
    }

    //initializes navigation bar
    private func initNavigation() {
        //sets title to chat room name
        self.navigationItem.title = chatRoom.name
    }
    
    // Sets up the message bubbles
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    private func setupAvatarViewSize() {
        // TODO: add support for avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    }
    
    func loadMessages() {
        //init chat rooms
        self.messages = []
        
        messageService.getMessagesInChatRoom(chatRoom.id, callback: { (messages, error) in
            if let messages = messages {
                for message in messages {
                    do {
                        let iv = GlobalUtilities.hexToByteArray(message.stamp)
                        let body = try String(data: NSData.withBytes(AES(key: self.appCert, iv: iv, blockMode: .CBC, padding: PKCS7()).decrypt(GlobalUtilities.hexToByteArray(message.body))), encoding: NSUTF8StringEncoding)
                        let msg = JSQMessage(senderId: message.senderId, senderDisplayName: message.senderName,
                            date: NSDate(timeIntervalSince1970: message.messageSent), text: body)
                        self.messages.append(msg)
                        self.finishReceivingMessage()
                    }
                    catch {
                        print(error)
                    }
                }
            }
            else {
                //TODO: change this to log instead of print
                print(error?.description)
            }
        })
    }
    
    func addMessage(text: String) {
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        messages.append(message)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        do {
            let iv = AES.randomIV(AES.blockSize)
            let stamp = NSData.withBytes(iv).toHexString()
            let body = try NSData.withBytes(AES(key: appCert, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(text.utf8.map({$0}))).toHexString()
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
    }
}

// Delegate/DataSource Methods
extension ChatRoomViewController {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        // TODO: this checks who the message is sent by and returns the correct message bubble
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    // For the display name of messages
    override func collectionView(collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        
        guard let senderDisplayName = message.senderDisplayName else {
            assertionFailure()
            return nil
        }
        return NSAttributedString(string: senderDisplayName)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 13 //or what ever height you want to give
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        // TODO: Add support for avatars here
        return nil
    }
    
}
