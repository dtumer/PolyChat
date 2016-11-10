//
//  UserServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

protocol UserServiceProtocol {
    /*
     * Get a specific user from the USERS table
     *
     * @param uid       - The ID of the user to get
     * @param callback  - The callback function. Called with the user object or an error if there is one
     */
    func getUser(_ uid: String, callback: @escaping (User?, NSError?) -> ())
    
    /*
     * Gets all users in the USERS table
     *
     * @param callback  - The callback function. Called with a list of the users objects or an error if there is one
     */
    func getAllUsers(_ callback: @escaping ([User]?, NSError?) -> ())
    
    /*
     * Puts a user into the USERS table
     *
     * @param uid       - The ID of the user to add
     * @param user      - The user object to add
     * @param callback  - The callback function. Called with an error if there is one
     */
    func putUser(_ uid: String?, user: User, callback: @escaping (NSError?) -> ())
    
    
    /*
     * -----------------------------------
     * COMPOSITE DATABASE ACCESS FUNCTIONS
     * -----------------------------------
     */
    
    /*
     * Gets all users enrolled in a course.
     *
     * @param courseId  - The ID of the course to add
     * @param userId    - The ID of the user logged in (don't get their information)
     * @param callback  - The callback function. Called with the list of users or an error if there is one
     */
    func getAllUsersInACourse(_ courseId: String, userId: String, callback: @escaping ([User]?, NSError?) -> ())
}
