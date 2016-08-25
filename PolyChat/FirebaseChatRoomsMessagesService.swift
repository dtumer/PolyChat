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
    
    //helper function to get message ids as a list
    private func getMessageIds(chatRoomId: String, callback: ([String]?, NSError?) -> ()) {
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

/* COMPOSITE DATABASE FUNCTIONS */
extension FirebaseChatRoomsMessagesService {
    //adds a message reference to a chat room
    func addChatRoomsMessagesReference(chatRoomId: String, messageId: String, callback: (NSError?) -> ()) {
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
            ids.append(messageId)
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
}