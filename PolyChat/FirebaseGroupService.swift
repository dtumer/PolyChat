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
    
    let coursesGroupsService = CoursesGroupsServiceFactory.sharedInstance
    let usersGroupsService = UsersGroupsServiceFactory.sharedInstance
    let groupsUsersService = GroupsUsersServiceFactory.sharedInstance
    let userService = UserServiceFactory.sharedInstance
    
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
        let key = getAutoId(Constants.groupsDBKey)
        let childUpdates = [
            "/\(Constants.groupsDBKey)/\(key)": group.toDictionary()
        ]
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(nil, error as NSError?)
            }
            else {
                callback(key, nil)
            }
        })
    }
    
    func removeGroup(_ group: Group, callback: @escaping (NSError?) -> ()) {
        //nothing
    }
    
    //updates a chat room
    func updateGroup(groupId: String, group: Group, callback: @escaping (NSError?) -> ()) {
        let childUpdates = [
            "/\(Constants.groupsDBKey)/\(groupId)": group.toDictionary()
        ]
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(error as NSError?)
            }
            else {
                callback(nil)
            }
        })
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
                        let error = NSError(domain: "\(self.DOMAIN)getGroupsInCourseWithUser", code: 1, description: "Value in COURSES_GROUPS is not of type NSArray")
                        callback(nil, error)
                    }
                })
            }
            else {
                let error = NSError(domain: "\(self.DOMAIN)getGroupsInCourseWithUser", code: 1, description: "Value in USERS_GROUPS is not of type NSArray")
                callback(nil, error)
            }
        })
    }
    
    //creates a group
    func createGroup(_ courseId: String, users: [User], group: Group, callback: @escaping (NSError?) -> ()) {
        //1: Create group
        self.addGroup(group, callback: { (string, error) in
            if let error = error {
                callback(error)
            }
            else if let groupId = string {
                group.id = groupId
                
                //2: add group to COURSES_GROUPS
                self.coursesGroupsService?.addGroupReference(courseId, group: group, callback: { error in
                    if let error = error {
                        callback(error)
                    }
                    else {
                        //3: Add all users to GROUPS_USERS table
                        self.groupsUsersService?.addGroupsUsersReference(group.id, users: users, callback: { error in
                            if let error = error {
                                callback(error)
                            }
                            else {
                                //4: For each user add their reference in the USERS_GROUPS table
                                for user in users {
                                    self.usersGroupsService?.addUsersGroupsReference(user.id, groupId: group.id, callback: { error in
                                        if let error = error {
                                            callback(error)
                                        }
                                        else {
                                            callback(nil)
                                        }
                                    })
                                }
                            }
                        })
                    }
                })
            }
        })
    }
    
    //gets all users in a group
    func getAllUsersInAGroup(_ groupId: String, callback: @escaping ([User]?, NSError?) -> ()) {
        var users: [User] = []
        var numUsers = 0
        
        self.groupsUsersService?.getAllReferences(groupId, callback: { (userIds, error) in
            if let error = error {
                callback(nil, error)
            }
            else {
                if let userIds = userIds {
                    for uid in userIds {
                        self.userService?.getUser(uid, callback: { (user, error) in
                            if let error = error {
                                callback(nil, error)
                            }
                            else {
                                users.append(user!)
                                numUsers += 1
                            }
                            
                            //only callback if we've gone through all of them
                            if numUsers == userIds.count {
                                callback(users, nil)
                            }
                        })
                    }
                }
            }
        })
    }
    
    //removes a user from a chat room
    func removeUserFromGroup(_ groupId: String, uid: String, users: [String], callback: @escaping (NSError?) -> ()) {
        var newGroups: [String] = []
        
        //updates list of users
        self.groupsUsersService?.updateReference(groupId, users: users, callback: { error in
            if let error = error {
                callback(error)
            }
            else {
                //updates user object with new list of chat rooms
                self.usersGroupsService?.getGroupReferences(uid, callback: { (groups, error) in
                    if let error = error {
                        callback(error)
                    }
                    else {
                        for gId in groups! {
                            if gId != groupId {
                                newGroups.append(gId)
                            }
                        }
                        
                        self.usersGroupsService?.updateGroupReferences(uid, groups: newGroups, callback: { error in
                            if let error = error {
                                callback(error)
                            }
                            else {
                                callback(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    //adds users to a chat room
    func addUsersToGroup(groupId: String, users: [User], callback: @escaping (NSError?) -> ()) {
        self.groupsUsersService?.addGroupsUsersReference(groupId, users: users, callback: { error in
            if let error = error {
                callback(error)
            }
            else {
                //4: For each user add their reference in the USERS_CHATROOMS table
                for user in users {
                    self.usersGroupsService?.addUsersGroupsReference(user.id, groupId: groupId, callback: { error in
                        if let error = error {
                            callback(error)
                        }
                        else {
                            callback(nil)
                        }
                    })
                }
            }
        })
    }
}
