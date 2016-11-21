//
//  GroupsUsersServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class GroupsUsersServiceFactory {
    class var sharedInstance: GroupsUsersServiceProtocol! {
        struct Singleton {
            static let instance = GroupsUsersServiceFactory.getGroupsUsersService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getGroupsUsersService(_ serviceKey: String) -> GroupsUsersServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseGroupsUsersService()
        default:
            return FirebaseGroupsUsersService()
        }
    }
}
