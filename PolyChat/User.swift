//
//  User.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class User {
    var email: String! = ""
    var courses: [Course]! = []
    
    init(dictionary: NSDictionary) {
        self.email = dictionary["email"] as! String
        
        for course in dictionary["courses"] as! [String] {
            courses.append(Course(name: course))
        }
    }
    
    //returns string list of courses
    private func toStringCourses() -> [String] {
        var ret: [String] = []
        
        for course in self.courses {
            ret.append(course.name)
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