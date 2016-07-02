//
//  FirebaseMyCoursesService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

class FirebaseMyCoursesService: MyCoursesServiceProtocol {
    let userService = UserServiceFactory.getUserService(Constants.FIREBASE_SERVICE_KEY)
    
    //gets all courses that a user is enrolled in
    func getEnrolledCourses(uid: String, callback: ([Course]?, NSError?) -> ()) {
        userService.getUser(uid, callback: { (user, error) in
            if let user = user {
                callback(user.courses, nil)
            }
            
            callback(nil, error)
        })
    }
}