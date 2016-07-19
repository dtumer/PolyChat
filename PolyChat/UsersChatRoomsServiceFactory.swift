//
//  UsersChatRoomsServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UsersChatRoomsServiceFactory {
    class func getUsersCoursesService(serviceKey: String) -> UsersChatRoomsServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseUsersChatRoomsService()
        default:
            return MockUsersChatRoomsService()
        }
    }
}