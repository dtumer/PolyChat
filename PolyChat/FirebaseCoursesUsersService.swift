//
//  FirebaseCoursesUsersService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseCoursesUsersService: FirebaseDatabaseService, CoursesUsersServiceProtocol {
    let DOMAIN = "FirebaseCoursesUsersService::"
    
    let userService = UserServiceFactory.sharedInstance
    
    //get all users enrolled in a course
    func getEnrolledUsers(userId: String, courseId: String, callback: ([User]?, NSError?) -> ()) {
        let handle = dbRef.child(Constants.coursesUsersDBKey).child(courseId).observeEventType(.Value, withBlock: { snapshot in
            
            if let userIds = snapshot.value as? NSArray {
                for uid in userIds {
                    if let uid = uid as? String {
                        if uid != userId {
                            self.userService.getUser(uid, callback: { (user, error) in
                                if let error = error {
                                    callback(nil, error)
                                }
                                else {
                                    callback([user!], nil)
                                }
                            })
                        }
                    }
                    else {
                        let error = NSError(domain: self.DOMAIN, code: 0, description: "Course id for some reason is not a String")
                        callback(nil, error)
                        return
                    }
                }
            }
            else {
                let error = NSError(domain: self.DOMAIN, code: 0, description: "Value in DB is not NSArray")
                callback(nil, error)
                return
            }
        })
        
        self.handles.append(handle)
    }
    
    //enroll a user in a course
    func enrollUserInCourse(courseId: String, userId: String, callback: (NSError?) -> ()) {
        
    }
}