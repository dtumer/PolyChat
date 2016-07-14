//
//  UserCourseManager.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

//firebase manager for keeping track of a user's enrolled courses and what groups they are in
/*
 * Structure of the Users-Courses manager:
 *
 *  course: {
        "course_id1": [
            "groups": [
                "group_id1",
                "group_id2",
                "group_id3",
                "group_id4",
                etc...
            ],
            "chats": [
                "chat_id1",
                "chat_id2",
                "chat_id3",
                "chat_id4",
                etc...
            ]
        ]
    }
 */
class UserCourseManager {
    let CHATS = "chats"
    let GROUPS = "groups"
    
    var courses: [String: NSDictionary] = [:]
    
    init(courses: [String: NSDictionary]) {
        self.courses = courses
    }
    
    //Adds a course to the manager
    func addCourse(courseId: String) {
        
    }
    
    //Adds a group to the given course
    func addGroupToCourse(courseId: String, groupId: String) {
        
        //self.courses[courseId][GROUPS]
    }
}