//
//  User.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

class User {
    var id: String! = ""
    var name: String! = ""
    var email: String! = ""
    var role: Int = Constants.USER_DEFAULT
    var notifications: Bool = Constants.NOTIFICATIONS_DEFAULT
    var is_anonymous: Bool = Constants.IS_ANONYMOUS_DEFAULT
    var userImageLink: String = "" //change this to default later
    
    //constructor given a user dictionary
    init(dictionary: NSDictionary) {
        //check if id is string
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        //check if id is int
        else if let id = dictionary["id"] as? Int {
            self.id = String(id)
        }
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        if let role = dictionary["role"] as? Int {
            self.role = role
        }
        if let notifications = dictionary["notifications"] as? Bool {
            self.notifications = notifications
        }
        if let is_anonymous = dictionary["is_anonymous"] as? Bool {
            self.is_anonymous = is_anonymous
        }
    }
    
    //turns instance of User into a JSON object
    func toDictionary() -> NSDictionary {
        return [
            //don't need id for firebase, but should make it so that this model implements some delegate
            //"id": self.id,
            "name": self.name,
            "email": self.email,
            "role": self.role,
            "notifications": self.notifications,
            "is_anonymous": self.is_anonymous,
            "user_image_link": self.userImageLink
        ]
    }
}