//
//  FirebaseMessageService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseMessageService: FirebaseDatabaseService, MessageServiceProtocol {
    let DOMAIN = "FirebaseMessageService::"
    
    let chatRoomsMessagesService = ChatRoomsMessagesServiceFactory.sharedInstance
    
    //gets a message from the database
    func getMessage(_ messageId: String, callback: @escaping (Message?, NSError?) -> ()) {
        dbRef.child(Constants.messagesDBKey).child(messageId).observeSingleEvent(of: .value, with: { snapshot in
            if let messageDict = snapshot.value as? NSMutableDictionary {
                messageDict["id"] = messageId
                callback(Message(dictionary: messageDict), nil)
                return
            }
            
            let error = NSError(domain: "\(self.DOMAIN)getMessage", code: 0, description: "Error getting message by that ID")
            
            callback(nil, error)
            return
        })
    }
    
    //adds a message to the db
    func addMessage(_ message: Message, callback: @escaping (String?, NSError?) -> ()) {
        let key = getAutoId(Constants.messagesDBKey)
        let childUpdates = ["/\(Constants.messagesDBKey)/\(key)": message.toDictionary()]
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(nil, error as NSError?)
            }
            else {
                callback(key, nil)
            }
        })
    }
}

/* COMPOSITE DATABASE FUNCTIONS */
extension FirebaseMessageService {
    //gets all messages in a chat room
    func getMessagesInChatRoom(_ chatRoomId: String, last n: Int, callback: @escaping (Message?, NSError?) -> ()) {
//        var messages: [Message] = []
//        var numMessages = 0
        
        let handle = dbRef.child(Constants.chatRoomsMessagesDBKey).child(chatRoomId).queryLimited(toLast: UInt(n)).observe(.childAdded, with: { snapshot in
//            if let msgArr = snapshot.value as? NSArray {
//                for msgId in msgArr {
//                    if let msgId = msgId as? String {
//                        self.getMessage(msgId, callback: { (msg, error) in
//                            if let error = error {
//                                callback(nil, error)
//                                return
//                            }
//                            else {
//                                messages.append(msg!)
//                                numMessages += 1
//                            }
//                            
//                            //callback when all messages are loaded
//                            if numMessages == msgArr.count {
//                                callback(messages, nil)
//                            }
//                        })
//                    }
//                    else {
//                        let error = NSError(domain: "\(self.DOMAIN)getMessagesInChatRoom", code: 0, description: "Message ID is not a string in the DB")
//                        callback(nil, error)
//                        return
//                    }
//                }
//            }
            if let msgId = snapshot.value as? String {
                self.getMessage(msgId, callback: { (msg, error) in
                    if let error = error {
                        callback(nil, error)
                        return
                    }
                    else {
                        callback(msg!, nil)
                    }
                })
            }
            else {
                let error = NSError(domain: "\(self.DOMAIN)getMessagesInChatRoom", code: 1, description: "Value in DB is not of type NSArray")
                callback(nil, error)
                return
            }
        })
        
        self.handles.append(handle)
    }
    
    //adds a message to the chat room
    func addMessageToChatRoom(_ chatRoomId: String, message: Message, callback: @escaping (NSError?) -> ()) {
        //1: Add message to MESSAGES table
        self.addMessage(message, callback: { (key, error) in
            if let error = error {
                callback(error)
            }
            else {
                //2: Add reference to message in chat room
                self.chatRoomsMessagesService?.addChatRoomsMessagesReference(chatRoomId: chatRoomId, messageId: key!, callback: { error in
                    if let error = error {
                        callback(error)
                    }
                    else {
                        callback(nil)
                    }
                })
            }
        })
    }
}
