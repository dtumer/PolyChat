//
//  CoursesUsersServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class CoursesUsersServiceFactory {
    class var sharedInstance: CoursesUsersServiceProtocol! {
        struct Singleton {
            static let instance = CoursesUsersServiceFactory.getCoursesUsersService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getCoursesUsersService(_ serviceKey: String) -> CoursesUsersServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseCoursesUsersService()
        default:
            return FirebaseCoursesUsersService()
        }
    }
}
