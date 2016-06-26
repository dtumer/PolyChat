//
//  MyCoursesServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class MyCoursesServiceFactory {
    class func getMyCoursesService(serviceKey: String) -> MyCoursesServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseMyCoursesService()
        default:
            return MockMyCoursesService()
        }
    }
}
