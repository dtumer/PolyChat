//
//  UsersCoursesServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UsersCoursesServiceFactory {
    class func getUsersCoursesService(serviceKey: String) -> UsersCoursesServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseUsersCoursesService()
        default:
            return MockUsersCoursesService()
        }
    }
}