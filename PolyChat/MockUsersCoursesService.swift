//
//  MockUsersCoursesService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockUsersCoursesService: UsersCoursesServiceProtocol {
    func getEnrolledCourses(userId: String, callback: ([Course]?, NSError?) -> ()) {
        
    }
    
    func enrollUserInCourse(userId: String, courseId: String, callback: (NSError?) -> ()) {
        
    }
}
