//
//  UsersGroupsServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UsersGroupsServiceFactory {
    class var sharedInstance: UsersGroupsServiceProtocol! {
        struct Singleton {
            static let instance = UsersGroupsServiceFactory.getUsersGroupsService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    private class func getUsersGroupsService(serviceKey: String) -> UsersGroupsServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseUsersGroupsService()
        default:
            return FirebaseUsersGroupsService()
        }
    }
}