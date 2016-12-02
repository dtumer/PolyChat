//
//  GroupServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol GroupServiceProtocol {
    /*
     * Gets a specific group based on the ID
     * 
     * @param groupId  - ID of the group to get
     * @param callback - Callback function. Called with group if there is one, error otherwise
     */
    func getGroup(_ groupId: String, callback: @escaping (Group?, NSError?) -> ())
    
    /*
     * Gets all groups from the GROUP table
     *
     * @param callback - Callback function. Called with list of groups, or error otherwise
     */
    func getAllGroups(_ callback: @escaping ([Group]?, NSError?) -> ())
    
    /*
     * Adds a group to the GROUP table
     *
     * @param group - The group to be stored
     * @param callback - The callback function. Called with the ID of the new db object or error otherwise
     */
    func addGroup(_ group: Group, callback: @escaping (String?, NSError?) -> ())
    
    /*
     * Removes a group from the GROUP table
     *
     * @param group - The group to be removed
     * @param callback - The callback function. Called with error if there is one
     */
    func removeGroup(_ group: Group, callback: @escaping (NSError?) -> ())


    /*
     * -----------------------------------
     * COMPOSITE DATABASE ACCESS FUNCTIONS
     * -----------------------------------
     */
    
    /*
     * Gets all groups in a course
     *
     * @param courseId  - The course ID of the specific course we are looking in
     * @param userId    - The user ID of the user we are finding groups for
     * @param callback  - The callback function. Called with list of groups that user is in
     */
    func getGroupsInCourseWithUser(_ courseId: String, userId: String, callback: @escaping ([Group]?, NSError?) -> ())
    
    /*
     * Creates a group and adds it to the appropriate tables
     *
     * @param courseId  - The course this chat room is being added to
     * @param users     - The list of users being added to the group
     * @param group  - The group object to be added to the GROUPS table
     * @param callback  - The callback function. Called with an error if there is one.
     */
    func createGroup(_ courseId: String, users: [User], group: Group, callback: @escaping (NSError?) -> ())
    
    /*
     * Gets all the users that are in the specified group
     *
     * @param groupId    - The id of the group to get the users for
     */
    func getAllUsersInAGroup(_ groupId: String, callback: @escaping ([User]?, NSError?) -> ())
    
    /*
     * Remove user from group
     *
     * @param groupId    - Id of the chat room to remove the user from
     * @param uId           - Id of the user to remove
     * @param users         - user ids of all the users in the room
     * @param callback      - callback function
     */
    func removeUserFromGroup(_ groupId: String, uid: String, users: [String], callback: @escaping (NSError?) -> ())
    
    /*
     * adds a user to a group
     *
     * @param groupId    - Id of the chat room
     * @param uid           - Id of the user to add
     * @param callback      - callback function
     */
    func addUsersToGroup(groupId: String, users: [User], callback: @escaping (NSError?) -> ())
}
