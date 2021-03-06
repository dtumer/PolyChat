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
    
    //gets a course from the database
    func getCourse(_ courseId: String, callback: @escaping (Course?, NSError?) -> ()) {
        dbRef.child(Constants.coursesDBKey).child(courseId).observeSingleEvent(of: .value, with: { snapshot in
            if let courseDict = snapshot.value as? NSMutableDictionary {
                courseDict["id"] = courseId
                callback(Course(dictionary: courseDict), nil)
                return
            }
            
            let error = NSError(domain: "\(self.DOMAIN)getCourse", code: 0, description: "Error getting course by that ID")
            
            callback(nil, error)
            return
        })
    }
    
    //gets all the courses from the database
    func getAllCourses(_ callback: @escaping ([Course]?, NSError?) -> ()) {
        dbRef.child(Constants.coursesDBKey).observeSingleEvent(of: .value, with: { snapshot in
            var courses: [Course] = []
            
            if let coursesDict = snapshot.value as? NSDictionary {
                for (key, course) in coursesDict {
                    if let courseDict = course as? NSMutableDictionary {
                        courseDict["id"] = key
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
    func addCourse(_ course: Course, callback: @escaping (String?, NSError?) -> ()) {
        let key = getAutoId(Constants.coursesDBKey)
        let childUpdates = ["/\(Constants.coursesDBKey)/\(key)": course.toDictionary()]
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(nil, error as NSError?)
            }
            else {
                callback(key, nil)
            }
        })
    }
    
    //removes a course from the database
    func removeCourse(_ course: Course, callback: @escaping (NSError?) -> ()) {
        dbRef.child(Constants.coursesDBKey).child(course.id).removeValue(completionBlock: { (error, ref) in
            if let error = error {
                callback(error as NSError?)
                return
            }
            
            callback(nil)
            return
        })
    }
}

/* COMPOSITE DATABASE TABLE FUNCTIONS */
extension FirebaseCourseService {
    //gets all courses a user is enrolled in
    func getCoursesUserIsEnrolledIn(_ userId: String, callback: @escaping ([Course]?, NSError?) -> ()) {
        var courses: [Course] = []
        var numCourses = 0
        
        dbRef.child(Constants.usersCoursesDBKey).child(userId).observeSingleEvent(of: .value, with: { snapshot in
            if let coursesArr = snapshot.value as? NSArray {
                for cId in coursesArr {
                    if let courseId = cId as? String {
                        self.getCourse(courseId, callback: { (course, error) in
                            if let error = error {
                                callback(nil, error)
                                return
                            }
                            else {
                                courses.append(course!)
                                numCourses += 1
                            }
                            
                            //only callback when everything is complete
                            if numCourses == coursesArr.count {
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
    
    //enrolls a student in a course
    func enrollStudentInCourse(_ userId: String, courseId: String, callback: @escaping (NSError?) -> ()) {
        //TODO finish this
    }
}
