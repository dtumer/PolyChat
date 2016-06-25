//
//  AuthServiceProvider.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class AuthServiceFactory {
    class func getAuthService(serviceKey: String) -> AuthServiceProtocol? {
        switch serviceKey {
            case Constants.FIREBASE_SERVICE_KEY:
                return FirebaseAuthService()
            default:
                return MockAuthService()
        }
    }
}