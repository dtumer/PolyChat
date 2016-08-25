//
//  MockCourseService.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockCourseService: CourseServiceProtocol {
    func getAllCourses(callback: ([Course]?, NSError?) -> ()) {
        
    }
    
    func getCourse(courseId: String, callback: (Course?, NSError?) -> ()) {
        
    }
    
    func addCourse(course: Course, callback: (String?, NSError?) -> ()) {
        
    }
    
    func removeCourse(course: Course, callback: (NSError?) -> ()) {
        
    }
}

extension MockCourseService {
    func getCoursesUserIsEnrolledIn(userId: String, callback: ([Course]?, NSError?) -> ()) {
        
    }
    
    func enrollStudentInCourse(userId: String, courseId: String, callback: (NSError?) -> ()) {
        
    }
}
