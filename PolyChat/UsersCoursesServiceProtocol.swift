//
//  UsersCoursesServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol UsersCoursesServiceProtocol {
    /*
     * Adds a reference of a course to the USERS_COURSES table
     *
     * @param userId    - The ID of the user to add a course reference to in the DB
     * @param courseId  - The ID of the course to add to the user in the DB
     * @param callback  - The callback function. Called with an error if there is one
     */
    func addUserCourseReference(userId: String, courseId: String, callback: (NSError?) -> ())
    
    /*
     * Removed a reference of a course from the USERS_COURSES table
     *
     * @param userId    - The ID of the user to remove the course reference from in the DB
     * @param courseId  - The ID of the course to remove from the DB
     * @param callback  - The callback function. Called with an error if there is one
     */
    func removeUserCourseReference(userId: String, courseId: String, callback: (NSError?) -> ())
}
