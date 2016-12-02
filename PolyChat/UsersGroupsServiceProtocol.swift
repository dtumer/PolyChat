//
//  UsersGroupsServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

protocol UsersGroupsServiceProtocol {
    /*
     * Adds a reference to the USERS_GROUPS table that links a user to a group
     *
     * @param userId        - The ID of the user to add to the group
     * @param groupId       - The ID of the gorup to add the specified user to
     * @param callback      - The callback function. Called with an error if there is one
     */
    func addUsersGroupsReference(_ userId: String, groupId: String, callback: @escaping (NSError?) -> ())
    
    /*
     * Removes a reference in USERS_GROUPS table that links the specified user to the specified group
     *
     * @param userId        - The ID of the user to remove from the group
     * @param groupId       - The ID of the group to remove the specified user from
     * @param callback      - The callback function. Called with an error if there is one
     *
     * NOTE: MAKE SURE TO CALL SUBSEQUENT FUNCTION IN GroupsUsersService AS WELL
     */
    func removeUsersGroupsReference(_ userId: String, groupId: String, callback: @escaping (NSError?) -> ())
    
    /*
     * gets all references for groups for a user
     *
     * @param userId    - Id of the user
     * @param callback  - callback function
     */
    func getGroupReferences(_ userId: String, callback: @escaping ([String]?, NSError?) -> ())
    
    /*
     * Updates chat room references
     *
     * @param userId    - Id of the user
     * @param chatRooms - chat room ids
     */
    func updateGroupReferences(_ userId: String, groups: [String], callback: @escaping (NSError?) -> ())
}
