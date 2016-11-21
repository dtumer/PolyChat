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
    
    //adds references to the users in the CHATROOMS_USERS table
    func addGroupsUsersReference(_ groupId: String, users: [User], callback: @escaping (NSError?) -> ()) {
        self.getUserIdsInGroup(groupId, callback: { (userIds, error) in
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
    
    //gets all user ids in a specified chat room
    func getUserIdsInGroup(_ groupId: String, callback: @escaping ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.groupsUsersDBKey).child(groupId).observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getUserIdsInGroup", code: 0, description: "error there are no values in the db"))
            }
        })
    }
}
