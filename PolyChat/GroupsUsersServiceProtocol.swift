//
//  GroupsUsersServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol GroupsUsersServiceProtocol {
    /*
     * Adds a reference to the users in the specific groups
     *
     * @param groupId       - The ID of the group to add the reference to
     * @param users         - The list of users to add references to in the group
     * @param callback      - The callback function. Called with an error if there is one
     */
    func addGroupsUsersReference(_ groupId: String, users: [User], callback: @escaping (NSError?) ->())
    
    /*
     * Removes reference to users in the group
     *
     * @param groupId       - The ID of the group to remove the reference from
     * @param users         - The list of users to remove references from in the group
     * @param callback      - The callback function. Called with an error if there is one
     */
    func removeGroupsUsersReference(_ groupId: String, users: [User], callback: @escaping (NSError?) -> ())
    
    /*
     * Gets all references given a chat room id
     *
     * @param chatRoomId    - The id of the chat room to look for user references
     */
    func getAllReferences(_ groupId: String, callback: @escaping ([String]?, NSError?) -> ())
    
    /*
     * Gets all user reference objects
     *
     *
     */
    func getUserReferences(groupId: String, callback: @escaping ([User]?, NSError?) -> ())
    
    /*
     * updates a reference given list of user ids
     *
     * @param chatRoomId    - Id of chat room
     * @param users         - List of users in chat room
     * @param callback      - callback funciton
     */
    func updateReference(_ groupId: String, users: [String], callback: @escaping (NSError?) -> ())
}
