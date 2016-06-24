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
class FirebaseAuthService: AuthServiceDelegate {
    
    func signUpUser(email: String, passHash: String) {
        FIRAuth.auth()?.createUserWithEmail(email, password: passHash) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            //self.setDisplayName(user!)
        }
    }
    
    func loginUser(email: String, passHash: String) {
        
    }
    
    func loginAnonymousUser() {
        
    }
    
}