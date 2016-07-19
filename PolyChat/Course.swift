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
    }
    
    //Converts this course object to a JSON object
    func toDictionary() -> NSDictionary {
        return [
            //"id": self.id,
            "name": self.name
        ]
    }
    
    //Checks if the course is a valid course
    func isValid() -> Bool {
        if(self.name.isEmpty) {
            return false
        }
        
        return !(self.name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "")
    }
}