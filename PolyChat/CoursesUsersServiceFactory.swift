//
//  CoursesUsersServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class CoursesUsersServiceFactory {
    class func getCoursesUsersService(serviceKey: String) -> CoursesUsersServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseCoursesUsersService()
        default:
            return MockCoursesUsersService()
        }
    }
}