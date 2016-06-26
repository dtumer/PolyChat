//
//  DataServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UserServiceFactory {
    class func getUserService(serviceKey: String) -> UserServiceProtocol {
        switch serviceKey {
            case Constants.FIREBASE_SERVICE_KEY:
                return FirebaseUserService()
            default:
                return MockUserService()
        }
    }
}
