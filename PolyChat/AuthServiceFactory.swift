//
//  AuthServiceProvider.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class AuthServiceFactory {
    class var sharedInstance: AuthServiceProtocol! {
        struct Singleton {
            static let instance = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getAuthService(_ serviceKey: String) -> AuthServiceProtocol? {
        switch serviceKey {
            case Constants.FIREBASE_SERVICE_KEY:
                return FirebaseAuthService()
            default:
                return FirebaseAuthService()
        }
    }
}
