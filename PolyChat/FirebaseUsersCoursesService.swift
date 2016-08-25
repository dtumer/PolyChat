//
//  FirebaseUsersCoursesService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUsersCoursesService: FirebaseDatabaseService, UsersCoursesServiceProtocol {
    let DOMAIN = "FirebaseUsersCoursesService::"
        
    //adds a reference to the USERS_COURSES table
    func addUserCourseReference(userId: String, courseId: String, callback: (NSError?) -> ()) {
        
    }
    
    //removes a reference from the USERS_COURSES table
    func removeUserCourseReference(userId: String, courseId: String, callback: (NSError?) -> ()) {
        
    }
}