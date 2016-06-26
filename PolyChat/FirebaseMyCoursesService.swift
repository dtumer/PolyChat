//
//  FirebaseMyCoursesService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class FirebaseMyCoursesService: MyCoursesServiceProtocol {
    let userService = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
    
    func getEnrolledCourses(uid: String, callback: ([Course]?) -> ()) {
        userService.getUser(uid, callback: { user in
            if let user = user {
                callback(user.courses)
            }
            
            callback(nil)
        })
    }
}