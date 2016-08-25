//
//  MockUserService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

class MockUserService: UserServiceProtocol {
    //gets a user
    func getUser(uid: String, callback: (User?, NSError?) -> ()) {
        
    }
    
    //gets all users
    func getAllUsers(callback: ([User]?, NSError?) -> ()) {
        
    }
    
    //adds a user
    func putUser(uid: String?, user: User, callback: (NSError?) -> ()) {
        
    }
}

extension MockUserService {
    //gets all users in a course
    func getAllUsersInACourse(courseId: String, userId: String, callback: ([User]?, NSError?) -> ()) {
        
    }
}
