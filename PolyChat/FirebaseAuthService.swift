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
class FirebaseAuthService: AuthServiceProtocol {
    let userService = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
    
    func signUpUser(email: String, passHash: String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: passHash) { (user, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription))")
                return
            }
            
            //create user object to add to users table
            let userObj = [
                "email": email,
                
                //get rid of this eventually
                "courses": [
                    "CPE-141-01",
                    "CPE-141-02",
                    "ENGL-134-05",
                    "PSY-202-01",
                ],
            ]
            
            self.userService.putUser(user!.uid, user: User(dictionary: userObj), callback: { error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                }
            })
        }
    }
    
    //function for logging a user in given an email address and password hash
    func loginUser(email: String, passHash: String, callback: (NSError?) -> ()) {
        var retErr: NSError? = nil
        
        FIRAuth.auth()?.signInWithEmail(email, password: passHash, completion: { (user, error) in
            if let error = error {
                print("ERROR: " + error.localizedDescription)
                retErr = NSError(domain: error.localizedDescription, code: 0, userInfo: nil)
            }
            else {
                print("Signed in user " + user!.uid + " successfully!")
            }
            
            callback(retErr)
        })
    }
    
    //logs a user in anonymously
    func loginAnonymousUser() {
        //none
    }
    
    //checks if a user is logged in
    func hasOpenSession() -> Bool {
        return FIRAuth.auth()?.currentUser == nil
    }
    
    func getUserData() -> NSDictionary? {
        var retUser: [String:AnyObject]? = [:]
        
        if let user = FIRAuth.auth()?.currentUser {
            retUser!["uid"] = user.uid
            retUser!["email"] = user.email
        }
        
        return retUser
    }
}