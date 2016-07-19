//
//  FirebaseCourseService.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseCourseService: CourseServiceProtocol {
    let courseRef = FIRDatabase.database().reference()
    let userService = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
    
    //gets a course from the database
    func getCourse(courseId: String, callback: (Course?, NSError?) -> ()) {
        
    }
    
    //puts a course in the database
    func putCourse(courseId: String, course: Course, callback: (NSError?) -> ()) {
        
    }
    
    //enrolls a user in the course specified
    func enrollUserInCourse(userId: String, courseId: String, callback: (NSError?) -> ()) {
        userService.getUser(userId, callback: { (user, error) in
            //do something if there's an error
            if let error = error {
                //TODO SHOULD LOG OUT WITH XCLOGGER
                callback(error)
            }
            
            //let success = user!.coursesManager.enrollUserInCourse(userId, courseId: courseId)
            
            //check if adding the course was successful
//            if success {
//                //resync user with DB
//                self.userService.putUser(user!.id, user: user!, callback: { error in
//                    if let error = error {
//                        callback(error)
//                    }
//                    
//                    callback(nil)
//                })
//            }
//            else {
//                //create error and send it back
//                callback(NSError(domain: "FirebaseCourseService::enrollUserInCourse()", code: 0, description: "Error adding course. User already enrolled in course"))
//            }
        })
    }
}