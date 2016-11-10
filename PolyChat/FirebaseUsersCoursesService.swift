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
    func addUserCourseReference(_ userId: String, courseId: String, callback: @escaping (NSError?) -> ()) {
        
    }
    
    //removes a reference from the USERS_COURSES table
    func removeUserCourseReference(_ userId: String, courseId: String, callback: @escaping (NSError?) -> ()) {
        
    }
}
