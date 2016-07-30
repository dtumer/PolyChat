//
//  FirebaseUserService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Firebase

class FirebaseUserService: FirebaseDatabaseService, UserServiceProtocol {
    let DOMAIN = "FirebaseUserService::"
    
    // Gets a user from the database given their UID. Passes an NSError with code 0 if user is not found
    func getUser(uid: String, callback: (User?, NSError?) -> ()) {
        dbRef.child(Constants.usersDBKey).child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
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
    
    // Gets all the users from the database
    func getAllUsers(callback: ([User]?, NSError?) -> ()) {
        dbRef.child(Constants.usersDBKey).observeSingleEventOfType(.Value, withBlock: { snapshot in
            var users: [User] = []
            
            if let usersDict = snapshot.value as? NSDictionary {
                for (key, user) in usersDict {
                    if let userDict = user as? NSMutableDictionary {
                        userDict["id"] = key
                        users.append(User(dictionary: userDict))
                    } else {
                        // TODO: Log error when dictionary not found
                        print("FirebaseUserService: NOT A DICTIONARY")
                    }
                }
            } else {
                let error = NSError(domain: self.DOMAIN, code: 0, description: "Error: User is not an NSDictionary in the database")
                callback(nil, error)
            }
            
            callback(users, nil)
        })
    }
    
    // Inserts a user into the database with the given UID
    func putUser(uid: String?, user: User, callback: (NSError?) -> ()) {
        if let userId = uid {
            let childVals = [
                "\(Constants.usersDBKey)/\(userId)": user.toDictionary(),
            ]
            
            //insert user into the database
            self.dbRef.updateChildValues(childVals, withCompletionBlock: { (error, ref) in
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