//
//  UsersCoursesServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol UsersCoursesServiceProtocol {
    //get all courses a user is enrolled in
    func getEnrolledCourses(userId: String, callback: ([Course]?, NSError?) -> ())
    
    //enrolls a specified student in a course
    func enrollUserInCourse(userId: String, courseId: String, callback: (NSError?) -> ())
}
