//
//  Course.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class Course {
    
    var name: String! = ""
    
    init(name: String) {
        self.name = name
    }
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as! String
    }
}