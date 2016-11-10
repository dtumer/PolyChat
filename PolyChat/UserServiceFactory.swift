//
//  DataServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UserServiceFactory {
    class var sharedInstance: UserServiceProtocol! {
        struct Singleton {
            static let instance = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getUserService(_ serviceKey: String) -> UserServiceProtocol {
        switch serviceKey {
            case Constants.FIREBASE_SERVICE_KEY:
                return FirebaseUserService()
            default:
                return FirebaseUserService()
        }
    }
}
