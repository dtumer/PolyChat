//
//  FirebaseCoursesUsersService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseCoursesUsersService: FirebaseDatabaseService, CoursesUsersServiceProtocol {
    let DOMAIN = "FirebaseCoursesUsersService::"
    
    //enroll a user in a course
    func enrollUserInCourse(_ courseId: String, userId: String, callback: @escaping (NSError?) -> ()) {
        
    }
}
