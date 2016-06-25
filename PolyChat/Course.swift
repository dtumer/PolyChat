//
//  Course.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class Course {
    
    var name: String!
    
    init(dictionary: NSDictionary) {
        self.name = dictionary["name"] as! String
    }
}