//
//  File.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/14/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

/*
 * This protocol defines the functions needed to allow a user to be enrolled in a course
 * as well as being able to be subscribed to groups and chats. Implement this as necessary
 * in order to manage this data.
 */
protocol UserCourseManagerProtocol {
    /* GETTER METHODS */
    //Gets all courses a user is enrolled in (list of ids)
    func getEnrolledCourses(uid: String) -> [String]
    
    //Gets all groups a user is participating in (list of ids)
    func getUsersGroups(uid: String, courseId: String) -> [String]
    
    //Gets all chats a user is participating in (list of ids)
    func getUsersChats(uid: String, courseId: String) -> [String]
    
    /* MUTATOR METHODS */
    //Enrolls specified user in the specified course
    func enrollUserInCourse(uid: String, courseId: String)
    
    //Adds a group to the specified user's course
    func addUserToGroup(uid: String, courseId: String, groupId: String)
    
    //Adds a user to specified chat in specified course
    func addUserToChat(uid: String, courseId: String, chatId: String)
}