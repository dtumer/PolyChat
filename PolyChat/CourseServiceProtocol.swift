//
//  CourseServiceProtocol.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol CourseServiceProtocol {
    //get course
    func getCourse(courseId: String, callback: (Course?, NSError?) -> ())

    //get all courses
    func getAllCourses(callback: ([Course]?, NSError?) -> ())
    
    //put course
    func addCourse(course: Course, callback: (NSError?) -> ())
    
    //enrolls a student in a course
    func enrollUserInCourse(userId: String, courseId: String, callback: (NSError?) -> ())
}