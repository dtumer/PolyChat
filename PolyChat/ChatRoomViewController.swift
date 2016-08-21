//
//  ChatRoomViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 8/17/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatRoomViewController: JSQMessagesViewController {

    // Services
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    var chatRoomsMessagesService: ChatRoomsMessagesServiceProtocol!
    
    // Current user
    var user: User!
    
    // Chat room object
    var chatRoom: ChatRoom!
    
    // Messages in the chat room
    var messages = [JSQMessage]()
    
    // Two types of message bubbles
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
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
        self.chatRoomsMessagesService = ChatRoomsMessagesServiceFactory.sharedInstance
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
    
    func addMessage(text: String) {
        let message = JSQMessage(senderId: user.id, displayName: user.name, text: text)
        messages.append(message)
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
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        // TODO: Add support for avatars here
        return nil
    }
    
}
