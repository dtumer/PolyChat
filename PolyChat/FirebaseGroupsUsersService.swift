//
//  FirebaseGroupsUsersService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseGroupsUsersService: FirebaseDatabaseService, GroupsUsersServiceProtocol {
    let DOMAIN = "FirebaseGroupsUsersService::"
    
    let userService = UserServiceFactory.sharedInstance
    
    //adds references to the users in the CHATROOMS_USERS table
    func addGroupsUsersReference(_ groupId: String, users: [User], callback: @escaping (NSError?) -> ()) {
        self.getAllReferences(groupId, callback: { (userIds, error) in
            var ids: [String] = []
            
            //check if there are userIds
            if let userIds = userIds {
                ids += userIds
            }
            else {
                if error?.code != 0 {
                    callback(error)
                    return
                }
            }
            
            //add ids
            for user in users {
                ids += [user.id]
            }
            
            let childUpdates = ["\(Constants.groupsUsersDBKey)/\(groupId)": ids]
            
            self.dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
                if let error = error {
                    callback(error as NSError?)
                }
                else {
                    callback(nil)
                }
            })
        })
    }
    
    //removes reference
    func removeGroupsUsersReference(_ groupId: String, users: [User], callback: @escaping (NSError?) -> ()) {
        //TODO finish for delete
    }
    
    //gets all references given the chat room id
    func getAllReferences(_ groupId: String, callback: @escaping ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.groupsUsersDBKey).child(groupId).observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getAllReferences", code: 0, description: "error there are no values in the db"))
            }
        })
    }
    
    //updates a reference given string of users
    func updateReference(_ groupId: String, users: [String], callback: @escaping (NSError?) -> ()) {
        let childUpdates = [
            "\(Constants.groupsUsersDBKey)/\(groupId)": users
        ]
        
        self.dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(error as NSError?)
            }
            else {
                callback(nil)
            }
        })
    }
    
    //gets uers references
    func getUserReferences(groupId: String, callback: @escaping ([User]?, NSError?) -> ()) {
        var users: [User] = []
        var numUsers = 0
        
        dbRef.child(Constants.groupsUsersDBKey).child(groupId).observe(.value, with: { snapshot in
            if let userIds = snapshot.value as? NSArray {
                for uid in userIds {
                    if let uid = uid as? String {
                        self.userService?.getUser(uid, callback: { (user, error) in
                            if let error = error {
                                callback(nil, error)
                                return
                            }
                            else {
                                users.append(user!)
                                numUsers += 1
                            }
                            
                            //only do the success callback when we have all the objects processed
                            if numUsers == userIds.count {
                                callback(users, nil)
                            }
                        })
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
    }
}
