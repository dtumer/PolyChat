//
//  FirebaseGroupService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseGroupService: FirebaseDatabaseService, GroupServiceProtocol {
    let DOMAIN = "FirebaseGroupService::"
    
    func getGroup(_ groupId: String, callback: @escaping (Group?, NSError?) -> ()) {
        dbRef.child(Constants.groupsDBKey).child(groupId).observeSingleEvent(of: .value, with: { snapshot in
            if let value = snapshot.value as? NSMutableDictionary {
                value["id"] = groupId
                
                callback(Group(dictionary: value), nil)
            }
            else {
                callback(nil, NSError(domain: "\(self.DOMAIN)getGroup", code: 0, description: "Error value is either no existent or is not a dictionary"))
            }
        })
    }
    
    func getAllGroups(_ callback: @escaping ([Group]?, NSError?) -> ()) {
        
    }
    
    func addGroup(_ group: Group, callback: @escaping (String?, NSError?) -> ()) {
        
    }
    
    func removeGroup(_ group: Group, callback: @escaping (NSError?) -> ()) {
        
    }
}

/* COMPOSITE DATABASE FUNCTIONS */
extension FirebaseGroupService {
    func getGroupsInCourseWithUser(_ courseId: String, userId: String, callback: @escaping ([Group]?, NSError?) -> ()) {
        var groups: [Group] = []
        var numGroups = 0
        
        //1: Get all groups a user is in
        dbRef.child(Constants.usersGroupsDBKey).child(userId).observeSingleEvent(of: .value, with: { snapshot in
            if let groupArr = snapshot.value as? NSArray {
                //Get all groups in a course
                self.dbRef.child(Constants.coursesGroupsDBKey).child(courseId).observeSingleEvent(of: .value, with: { snapshot in
                    //check if the course has any groups
                    if let groupCourseArr = snapshot.value as? NSArray {
                        //go through each group id and check if it's in the course
                        for crId in groupArr {
                            //if the group is in the course return it, or an error if there was one
                            if groupCourseArr.index(of: crId) >= 0 {
                                self.getGroup(crId as! String, callback: { (group, error) in
                                    if let error = error {
                                        callback(nil, error)
                                        return
                                    }
                                    else {
                                        groups.append(group!)
                                        numGroups += 1
                                    }
                                    
                                    //only callback with everything if we've processed everything correctly
                                    if numGroups == groupArr.count {
                                        callback(groups, nil)
                                    }
                                })
                            }
                        }
                    }
                    else {
                        let error = NSError(domain: "\(self.DOMAIN)getGroupsInCourseWithUser", code: 0, description: "Value in COURSES_GROUPS is not of type NSArray")
                        callback(nil, error)
                    }
                })
            }
            else {
                let error = NSError(domain: "\(self.DOMAIN)getGroupsInCourseWithUser", code: 0, description: "Value in USERS_GROUPS is not of type NSArray")
                callback(nil, error)
            }
        })
    }
    
    func createGroup(_ courseId: String, users: [User], group: Group, callback: @escaping (NSError?) -> ()) {
        
    }
}
