//
//  User.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

class User {
    var name: String! = ""
    var email: String! = ""
    var role: Int = Constants.USER_DEFAULT
    var userImageLink: String = "" //change this to default later
    var courses: [Course]! = []
    
    init(dictionary: NSDictionary) {
        self.email = dictionary["email"] as! String
        self.name = dictionary["name"] as! String
        
        
//        for (courseId, course) in dictionary["courses"] as! NSDictionary {
//            print(courseId)
//        }
    }
    
    //returns string list of courses
    private func toStringCourses() -> [String: Course] {
        var ret: [String: Course] = [:]
        
        for course in self.courses {
            
        }
        
        return ret
    }
    
    //turns the user into a dictionary
    func toDictionary() -> NSDictionary {
        return [
            "email": self.email,
            "courses": toStringCourses(),
            
        ]
    }
}