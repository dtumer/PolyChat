//
//  FirebaseUsersGroupsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseUsersGroupsService: FirebaseDatabaseService, UsersGroupsServiceProtocol {
    let DOMAIN = "FirebaseUsersGroupsService::"
    
    func addUsersGroupsReference(_ userId: String, groupId: String, callback: @escaping (NSError?) -> ()) {
        self.getGroupIds(userId, callback: { (groups, error) in
            var ids: [String] = []
            
            //if there are groups already in the table
            if let groups = groups {
                ids += groups
            }
            //there was an error
            else {
                if error?.code != 0 {
                    callback(error)
                    return
                }
            }
            
            //add id and push to db
            ids.append(groupId)
            let childUpdates = ["\(Constants.usersGroupsDBKey)/\(userId)": ids]
            
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
    
    func removeUsersGroupsReference(_ userId: String, groupId: String, callback: @escaping (NSError?) -> ()) {
        
    }
    
    //gets list of group ids
    func getGroupIds(_ userId: String, callback: @escaping ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.usersGroupsDBKey).child(userId).observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getGroupIds", code: 0, description: "error there is no values in the db"))
            }
        })
    }
}
