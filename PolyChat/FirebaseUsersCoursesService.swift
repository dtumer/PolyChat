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
    
    //gets all enrolled courses of a specified user
    func getEnrolledCourses(userId: String, callback: ([Course]?, NSError?) -> ()) {
        dbRef.child(Constants.usersCoursesDBKey).child(userId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let courses = snapshot.value {
                print(courses)
            }
        })
    }
    
    func enrollUserInCourse(userId: String, courseId: String, callback: (NSError?) -> ()) {
        
    }
}