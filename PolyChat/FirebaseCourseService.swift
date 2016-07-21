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
        dbRef.child(Constants.coursesDBKey).child(courseId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let courseDict = snapshot.value as? NSDictionary {
                callback(Course(dictionary: courseDict), nil)
            }
            
            let error = NSError(domain: "\(self.DOMAIN)getCourse", code: 0, description: "Error getting course by that ID")
            
            callback(nil, error)
        })
    }
    
    //gets all the courses from the database
    //NOT DONE
    func getAllCourses(callback: ([Course]?, NSError?) -> ()) {
        var retCourses: [Course] = []
        
        print(dbRef)
        
        dbRef.observeEventType(.Value, withBlock: { snapshot in
            if let courses = snapshot.value {
                print(courses)
            }
            else {
                print(snapshot.value)
            }
        })
    }
    
    //puts a course in the database
    func addCourse(course: Course, callback: (NSError?) -> ()) {
        let key = getAutoId(Constants.coursesDBKey)
        let childUpdates = ["/\(Constants.coursesDBKey)/\(key)": course.toDictionary()]
        
        dbRef.updateChildValues(childUpdates)
    }
}