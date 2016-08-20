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
    
    func getMessage(messageId: String, callback: (Message?, NSError?) -> ()) {
        dbRef.child(Constants.messagesDBKey).child(messageId).observeSingleEventOfType(.Value, withBlock: { snapshot in
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
}