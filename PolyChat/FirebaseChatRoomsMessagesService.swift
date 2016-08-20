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
    
    func getAllMessagesInChatRoom(chatRoomsId: String, callback: ([Message]?, NSError?) -> ()) {
        let handle = dbRef.child(Constants.chatRoomsMessagesDBKey).child(chatRoomsId).observeEventType(.Value, withBlock: { snapshot in
            if let messagesArr = snapshot.value as? NSArray {
                for mId in messagesArr {
                    if let mId = mId as? String {
                        self.messageService.getMessage(mId, callback: { (message, error) in
                            if let error = error {
                                callback(nil, error)
                                return
                            }
                            else {
                                callback([message!], nil)
                            }
                        })
                    }
                    else {
                        let error = NSError(domain: "\(self.DOMAIN)getAllMessagesInChatRoom", code: 1, description: "Message id for some reason is not a String")
                        callback(nil, error)
                        return
                    }
                }
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
}