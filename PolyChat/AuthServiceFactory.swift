//
//  AuthServiceProvider.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class AuthServiceFactory {
    class func getAuthService(serviceKey: String) -> AuthServiceDelegate? {
        switch serviceKey {
            case Constants.FIREBASE_SERVICE_KEY:
                return FirebaseAuthService()
            default:
                break
        }
        
        return nil
    }
}