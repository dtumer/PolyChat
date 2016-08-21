//
//  FirebaseChatRoomsMessagesService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseChatRoomsMessagesService: FirebaseDatabaseService, ChatRoomsMessagesServiceProtocol {
    let DOMAIN = "FirebaseChatRoomsMessagesService::"
    let messageService = MessageServiceFactory.sharedInstance
    
    func getAllMessagesInChatRoom(chatRoomsId: String, callback: (Message?, NSError?) -> ()) {
        let handle = dbRef.child(Constants.chatRoomsMessagesDBKey).child(chatRoomsId).observeEventType(.ChildAdded, withBlock: { snapshot in
            if let messageId = snapshot.value as? String {
                self.messageService.getMessage(messageId, callback: { (message, error) in
                    if let error = error {
                        callback(nil, error)
                        return
                    }
                    else {
                        callback(message!, nil)
                    }
                })
            }
            else {
                let error = NSError(domain: "\(self.DOMAIN)getAllMessagesInChatRoom", code: 1, description: "Value in DB is not of type NSArray")
                callback(nil, error)
                return
            }
        })
        
        //add handle to global handles
        handles.append(handle)
    }
    
    func addMessageToChatRoom(chatRoomId: String, message: Message, callback: (NSError?) -> ()) {
        //Add message to messages table
        let key = getAutoId(Constants.messagesDBKey)
        let childUpdates = ["/\(Constants.messagesDBKey)/\(key)": message.toDictionary()]
        
        //set the id of the chat room
        message.id = key
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(error)
            }
            else {
                //add message id to chat room
                self.getMessageIds(chatRoomId, callback: {(messages, error) in
                    var ids: [String] = []
                    
                    //if there are messages already in the table
                    if let messages = messages {
                        ids += messages
                    }
                        //there was an error
                    else {
                        if error?.code != 0 {
                            callback(error)
                            return
                        }
                    }
                    
                    //add id and push to db
                    ids.append(message.id)
                    let childUpdates = ["\(Constants.chatRoomsMessagesDBKey)/\(chatRoomId)": ids]
                    
                    self.dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
                        if let error = error {
                            callback(error)
                        }
                        else {
                            callback(nil)
                        }
                    })
                })
            }
        })
    }
    
    func getMessageIds(chatRoomId: String, callback: ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.chatRoomsMessagesDBKey).child(chatRoomId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getMessageIds", code: 0, description: "error there is no values in the db"))
            }
        })
    }
}