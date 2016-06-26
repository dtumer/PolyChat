//
//  MockAuthService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class MockAuthService: AuthServiceProtocol {
    func signUpUser(email: String, passHash: String) {
        
    }
    
    func loginUser(email: String, passHash: String, callback: (NSError?) -> ()) {
        callback(nil)
    }
    
    func loginAnonymousUser() {
        
    }
    
    func hasOpenSession() -> Bool {
        return false
    }
    
    func getUserData() -> NSDictionary? {
        return nil
    }
}
