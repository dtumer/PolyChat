//
//  MockCourseService.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockCourseService: CourseServiceProtocol {
    func getCourse(courseId: String, callback: (Course?, NSError?) -> ()) {
        
    }
    
    func putCourse(courseId: String, course: Course, callback: (NSError?) -> ()) {
        
    }
    
    func enrollUserInCourse(userId: String, courseId: String, callback: (NSError?) -> ()) {
        
    }
}