//
//  FirebaseChatRoomService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseChatRoomService: FirebaseDatabaseService, ChatRoomServiceProtocol {
    let DOMAIN = "FirebaseChatRoomService::"
    
    func getChatRoom(chatRoomId: String, callback: (ChatRoom?, NSError?) -> ()) {
        dbRef.child(Constants.chatRoomsDBKey).child(chatRoomId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? NSMutableDictionary {
                value["id"] = chatRoomId
                
                callback(ChatRoom(dictionary: value), nil)
            }
            else {
                callback(nil, NSError(domain: "\(self.DOMAIN)getChatRoom", code: 0, description: "Error value is either no existent or is not a dictionary"))
            }
        })
    }
}