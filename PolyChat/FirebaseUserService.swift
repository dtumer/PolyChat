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
            if let value = snapshot.value as? NSMutableDictionary{
                //add uid to dictionary
                value["id"] = uid
                
                callback(User(dictionary: value), nil)
            }
            else {
                callback(nil, NSError(domain: "FirebaseUserServices", code: 0, description: "No user with that UID found"))
            }
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

/* COMPOSITE FUNCTIONS */
extension FirebaseUserService {
    func getAllUsersInACourse(courseId: String, userId: String, callback: ([User]?, NSError?) -> ()) {
        let handle = dbRef.child(Constants.coursesUsersDBKey).child(courseId).observeEventType(.Value, withBlock: { snapshot in
            if let userIds = snapshot.value as? NSArray {
                for uid in userIds {
                    if let uid = uid as? String {
                        if uid != userId {
                            self.getUser(uid, callback: { (user, error) in
                                if let error = error {
                                    callback(nil, error)
                                }
                                else {
                                    callback([user!], nil)
                                }
                            })
                        }
                    }
                    else {
                        let error = NSError(domain: self.DOMAIN, code: 0, description: "Course id for some reason is not a String")
                        callback(nil, error)
                        return
                    }
                }
            }
            else {
                let error = NSError(domain: self.DOMAIN, code: 0, description: "Value in DB is not NSArray")
                callback(nil, error)
                return
            }
        })
        
        self.handles.append(handle)
    }
}