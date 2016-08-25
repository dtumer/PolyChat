//
//  UsersChatRoomsServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class UsersChatRoomsServiceFactory {
    class var sharedInstance: UsersChatRoomsServiceProtocol! {
        struct Singleton {
            static let instance = UsersChatRoomsServiceFactory.getUsersChatRoomsService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    private class func getUsersChatRoomsService(serviceKey: String) -> UsersChatRoomsServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseUsersChatRoomsService()
        default:
            return FirebaseUsersChatRoomsService()
        }
    }
}