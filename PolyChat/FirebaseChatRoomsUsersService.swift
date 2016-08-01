//
//  FirebaseChatRoomsUsersService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseChatRoomsUsersService: FirebaseDatabaseService, ChatRoomsUsersServiceProtocol {
    let DOMAIN = "FirebaseChatRoomsUsersService::"
    
    func getAllUsersInChatRoom(chatRoomsId: String, callback: ([User]?, NSError?) -> ()) {
        
    }
    
    //adds users to chatroom (works for adding first time as well as adding users to chat room later
    func addUsersToChatRoom(chatRoomId: String, users: [User], callback: (NSError?) -> ()) {
        self.getUserIdsInChatRoom(chatRoomId, callback: { (userIds, error) in
            var ids: [String] = []
            
            //check if there are userIds
            if let userIds = userIds {
                ids += userIds
            }
            else {
                if error?.code != 0 {
                    callback(error)
                    return
                }
            }
            
            //add ids
            for user in users {
                ids += [user.id]
            }
            
            let childUpdates = ["\(Constants.chatRoomsUsersDBKey)/\(chatRoomId)": ids]
            
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
    
    func getUserIdsInChatRoom(chatRoomId: String, callback: ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.chatRoomsUsersDBKey).child(chatRoomId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getChatRoomIds", code: 0, description: "error there are no values in the db"))
            }
        })
    }
}