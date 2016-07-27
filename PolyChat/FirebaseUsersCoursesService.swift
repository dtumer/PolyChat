//
//  FirebaseUsersCoursesService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUsersCoursesService: FirebaseDatabaseService, UsersCoursesServiceProtocol {
    let DOMAIN = "FirebaseUsersCoursesService::"
    
    let courseService = CourseServiceFactory.getCourseService(Constants.CURRENT_SERVICE_KEY)
    
    
    //gets all enrolled courses of a specified user
    func getEnrolledCourses(userId: String, callback: ([Course]?, NSError?) -> ()) {
        dbRef.child(Constants.usersCoursesDBKey).child(userId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            var courses: [Course] = []
            
            if let coursesArr = snapshot.value as? NSArray {
                for cId in coursesArr {
                    if let courseId = cId as? String {
                        self.courseService.getCourse(courseId, callback: { (course, error) in
                            if let error = error {
                                callback(nil, error)
                                return
                            }
                            else {
                                courses.append(course!)
                                callback(courses, nil)
                            }
                        })
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
    }
    
    func enrollUserInCourse(userId: String, courseId: String, callback: (NSError?) -> ()) {
        
    }
}