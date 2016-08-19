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
    var numLikes: Int = 0
    var numDislikes: Int = 0
    
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
        
        if let numLikes = dictionary["num_likes"] as? Int {
            self.numLikes = numLikes
        }
        
        if let numDislikes = dictionary["num_dislikes"] as? Int {
            self.numDislikes = numDislikes
        }
    }
    
    //Converts this instance of ChatRoom to JSON object
    func toDictionary() -> NSDictionary {
        return [
            //"id": self.id,
            "body": self.body,
            "sender_id": self.senderId,
            "num_likes": self.numLikes,
            "num_dislikes": self.numDislikes
        ]
    }
}