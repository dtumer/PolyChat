//
//  FirebaseUserService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Firebase

class FirebaseUserService: UserServiceProtocol {
    let userRef = FIRDatabase.database().reference()
    
    // Gets a user from the database given their UID. Passes an NSError with code 0 if user is not found
    func getUser(uid: String, callback: (User?, NSError?) -> ()) {
        userRef.child(Constants.usersDBKey).child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let value = snapshot.value {
                if value is NSNull {
                    return
                }
                
                callback(User(dictionary: value as! NSDictionary), nil)
                return
            }
            
            callback(nil, NSError(domain: "FirebaseUserServices", code: 0, description: "No user with that UID found"))
            return
        })
    }
    
    // Inserts a user into the database with the given UID
    func putUser(uid: String?, user: User, callback: (NSError?) -> ()) {
        if let userId = uid {
            let childVals = [
                "\(Constants.usersDBKey)/\(userId)": user.toDictionary(),
            ]
            
            //insert user into the database
            self.userRef.updateChildValues(childVals, withCompletionBlock: { (error, ref) in
                if let error = error {
                    callback(error)
                    return
                }
                
                callback(nil)
                return
            })
        }
        
        callback(NSError(domain: "FirebaseUserService", code: 1, description: "No UID provided"))
        return
    }
}