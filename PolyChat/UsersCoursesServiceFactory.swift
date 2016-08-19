//
//  UsersCoursesServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UsersCoursesServiceFactory {
    class var sharedInstance: UsersCoursesServiceProtocol! {
        struct Singleton {
            static let instance = UsersCoursesServiceFactory.getUsersCoursesService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    private class func getUsersCoursesService(serviceKey: String) -> UsersCoursesServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseUsersCoursesService()
        default:
            return MockUsersCoursesService()
        }
    }
}