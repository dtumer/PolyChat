//
//  FirebaseCourseService.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseCourseService: FirebaseDatabaseService, CourseServiceProtocol {
    let DOMAIN = "FirebaseCourseService::"
    let userService = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
    
    //gets a course from the database
    func getCourse(courseId: String, callback: (Course?, NSError?) -> ()) {
        dbRef.child(Constants.coursesDBKey).child(courseId).observeEventType(.Value, withBlock: { snapshot in
            if let courseDict = snapshot.value as? NSDictionary {
                callback(Course(dictionary: courseDict), nil)
                return
            }
            
            let error = NSError(domain: "\(self.DOMAIN)getCourse", code: 0, description: "Error getting course by that ID")
            
            callback(nil, error)
            return
        })
    }
    
    //gets all the courses from the database
    func getAllCourses(callback: ([Course]?, NSError?) -> ()) {
        dbRef.child(Constants.coursesDBKey).observeEventType(.Value, withBlock: { snapshot in
            var courses: [Course] = []
            
            if let coursesDict = snapshot.value as? NSDictionary {
                for (key, course) in coursesDict {
                    if let courseDict = course as? NSDictionary {
                        courses.append(Course(dictionary: courseDict))
                    }
                    else {
                        //LOG THIS IN A DIFFERENT WAY
                        print("NOT DICTIONARY")
                    }
                }
            }
            else {
                let error = NSError(domain: self.DOMAIN, code: 0, description: "Error: Course is not an NSDictionary in the database")
                callback(nil, error)
            }
            
            callback(courses, nil)
        })
    }
    
    //puts a course in the database
    func addCourse(course: Course, callback: (NSError?) -> ()) {
        let key = getAutoId(Constants.coursesDBKey)
        let childUpdates = ["/\(Constants.coursesDBKey)/\(key)": course.toDictionary()]
        
        dbRef.updateChildValues(childUpdates)
    }
}