//
//  AuthServices.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

/*
 * This class will contain methods for authenticating users through Firebase
*/
class FirebaseAuthService: FirebaseDatabaseService, AuthServiceProtocol {
    let DOMAIN = "FirebaseAuthService::"
    let userService = UserServiceFactory.sharedInstance
    
    func signUpUser(email: String, passHash: String, callback: (NSError?) -> ()) {
        FIRAuth.auth()?.createUserWithEmail(email, password: passHash) { (user, error) in
            if error != nil {
                callback(NSError(domain: "\(self.DOMAIN)signUpUser", code: 0, description: "Error with user creation. User already created"))
                return
            }
            
            //create user object to add to users table
            let userObj = [
                "name": GlobalUtilities.getNameFromEmail(email),
                "email": email,
                //"user_img_link": "", //change this to a default image in the future
                "receives_notifs": true, //change this to grab the notifications from the app delegate in the future
                "courses": [:]
            ]
            
            print(user!.uid)
            
            self.userService.putUser(user!.uid, user: User(dictionary: userObj), callback: { error in
                if error != nil {
                    callback(NSError(domain: "\(self.DOMAIN)signUpUser", code: 1, description: "Error user could not be stored in the database"))
                    return
                }
                
                callback(nil)
                return
            })
        }
    }
    
    //function for logging a user in given an email address and password hash
    func loginUser(email: String, passHash: String, callback: (NSError?) -> ()) {
        FIRAuth.auth()?.signInWithEmail(email, password: passHash, completion: { (user, error) in
            if let error = error {
                print("ERROR: " + error.localizedDescription)
                //let errrr = NSError(domain: error.localizedDescription, code: 0, userInfo: nil)
                
                callback(error)
                return
            }
            
            print("Signed in user " + user!.uid + " successfully!")
            
            //check if user is in USERS DB. If not add user
            self.userService.getUser(user!.uid, callback: { (user, error) in
                if user != nil {
                    callback(nil)
                    return
                }
                
                //TODO THERE COULD BE AN ISSUE HERE WHERE A USER COULD BE SIGNED UP BUT NOT ADDED TO THE DB
                callback(error)
                return
            })
        })
    }
    
    //logs a user in anonymously
    func loginAnonymousUser() {
        //none
    }
    
    //checks if a user is logged in
    func hasOpenSession() -> Bool {
        return FIRAuth.auth()?.currentUser != nil
    }
    
    func logout() -> Bool {
        do {
            try FIRAuth.auth()?.signOut()
            self.closeAllHandles()
            return true
        }
        catch {
            print("ERROR: User could not be logged out")
            return false
        }
    }
    
    func getCurrentUser(callback: (User?, NSError?) -> ()) {
        if let user = FIRAuth.auth()?.currentUser {
            userService.getUser(user.uid, callback: { user, error in
                if let error = error {
                    callback(nil, error)
                    return
                }
                if let user = user {
                    callback(user, nil)
                    return
                }
            })
        }
    }
    
    func getUserData() -> NSDictionary? {
        var retUser: [String:AnyObject]? = [:]
        
        if let user = FIRAuth.auth()?.currentUser {
            retUser![Constants.uidKey] = user.uid
            retUser![Constants.emailKey] = user.email
        }
        
        return retUser
    }
}