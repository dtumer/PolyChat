//
//  AuthServices.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

protocol AuthServiceProtocol {
    // function for signing up a user for the PolyChat service
    func signUpUser(_ email: String, passHash: String, callback: @escaping (NSError?) -> ())
    
    // function for logging in a user to the PolyChat service
    func loginUser(_ email: String, passHash: String, callback: @escaping (NSError?) -> ())
    
    // function for logging in an anonymous user to the PolyChat service
    func loginAnonymousUser()
    
    //checks whether or not a user is logged in
    func hasOpenSession() -> Bool
    
    // gets the currently logged in User
    func getCurrentUser(_ callback: @escaping (User?, NSError?) -> ())
    
    //grabs user data of the user that is logged in
    func getUserData() -> NSDictionary?
    
    //logs out a user
    func logout() -> Bool
}
