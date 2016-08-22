//
//  CoursesUsersServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol CoursesUsersServiceProtocol {
    //gets all users that are enrolled in a course
    //userId: user id of the logged in user (don't add them)
    func getEnrolledUsers(userId: String, courseId: String, callback: ([User]?, NSError?) -> ())
    
    //adds a user to a course
    func enrollUserInCourse(courseId: String, userId: String, callback: (NSError?) -> ())
}