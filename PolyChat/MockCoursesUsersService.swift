//
//  MockCoursesUsersService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockCoursesUsersService: CoursesUsersServiceProtocol {
    func getEnrolledUsers(userId: String, courseId: String, callback: ([User]?, NSError?) -> ()) {
        
    }
    
    func enrollUserInCourse(courseId: String, userId: String, callback: (NSError?) -> ()) {
        
    }
}
