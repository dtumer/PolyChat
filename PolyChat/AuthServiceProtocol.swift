//
//  AuthServices.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

protocol AuthServiceProtocol {
    // function for signing up a user for the PolyChat service
    func signUpUser(email: String, passHash: String)
    
    // function for logging in a user to the PolyChat service
    func loginUser(email: String, passHash: String, callback: (NSError?) -> ())
    
    // function for logging in an anonymous user to the PolyChat service
    func loginAnonymousUser()
    
    func hasOpenSession() -> Bool
}