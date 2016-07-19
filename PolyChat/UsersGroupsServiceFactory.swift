//
//  UsersGroupsServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UsersGroupsServiceFactory {
    class func getUsersCoursesService(serviceKey: String) -> UsersGroupsServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseUsersGroupsService()
        default:
            return MockUsersGroupsService()
        }
    }
}