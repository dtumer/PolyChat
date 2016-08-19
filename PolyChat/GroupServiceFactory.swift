//
//  GroupServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class GroupServiceFactory {
    class var sharedInstance: GroupServiceProtocol! {
        struct Singleton {
            static let instance = GroupServiceFactory.getGroupService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    private class func getGroupService(serviceKey: String) -> GroupServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseGroupService()
        default:
            return MockGroupService()
        }
    }
}