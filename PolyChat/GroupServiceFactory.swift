//
//  GroupServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class GroupServiceFactory {
    class func getGroupService(serviceKey: String) -> GroupServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseGroupService()
        default:
            return MockGroupService()
        }
    }
}