//
//  Message.swift
//  PolyChat
//
//  Created by Deniz Tumer on 8/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class Message {
    var id: String = ""
    var body: String = ""
    var senderId: String = ""
    var senderName: String = ""
    var numLikes: Int = 0
    var numDislikes: Int = 0
    var messageSent: Double = NSDate().timeIntervalSince1970
    
    init(dictionary: NSDictionary) {
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        else if let id = dictionary["id"] as? Int {
            self.id = String(id)
        }
        
        if let body = dictionary["body"] as? String {
            self.body = body
        }
        
        if let senderId = dictionary["sender_id"] as? String {
            self.senderId = senderId
        }
        
        if let senderName = dictionary["sender_name"] as? String {
            self.senderName = senderName
        }
        
        if let numLikes = dictionary["num_likes"] as? Int {
            self.numLikes = numLikes
        }
        
        if let numDislikes = dictionary["num_dislikes"] as? Int {
            self.numDislikes = numDislikes
        }
        
        if let messageSent = dictionary["message_sent"] as? Double {
            self.messageSent = messageSent
        }
    }
    
    //Converts this instance of ChatRoom to JSON object
    func toDictionary() -> NSDictionary {
        return [
            //"id": self.id,
            "body": self.body,
            "sender_id": self.senderId,
            "sender_name": self.senderName,
            "num_likes": self.numLikes,
            "num_dislikes": self.numDislikes,
            "message_sent": self.messageSent
        ]
    }
}