//
//  Course.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class Course {
    
    var id: String! = ""
    var name: String! = ""
    var users: [String] = []
    var groups: [String] = []
    
    init(dictionary: NSDictionary) {
        if let id = dictionary["id"] as? String {
            self.id = id
        }
        else if let id = dictionary["id"] as? Int {
            self.id = String(id)
        }
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        if let users = dictionary["users"] as? [String] {
            self.users = users
        }
        if let groups = dictionary["groups"] as? [String] {
            self.groups = groups
        }
    }
}