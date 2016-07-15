//
//  FirebaseUserCourseManager.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/14/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

//firebase manager for keeping track of a user's enrolled courses and what groups they are in
/*
 * Structure of the Users-Courses manager:
 *
 *  course: {
 *      "course_id1": [
 *          "groups": [
 *              "group_id1",
 *              "group_id2",
 *              "group_id3",
 *              "group_id4",
 *              etc...
 *          ],
 *          "chats": [
 *              "chat_id1",
 *              "chat_id2",
 *              "chat_id3",
 *              "chat_id4",
 *              etc...
 *          ]
 *      ]
 *  }
 */

// NOTE: uid is unneccessary for Firebase because this object is stored within the user object
class FirebaseUserCourseManager: UserCourseManagerProtocol {
    //use this to pass to each function because UID is not needed for firebase
    static let FAKE_UID = "12345"
    private let GROUPS_KEY = "groups"
    private let CHATS_KEY = "chats"
    
    var courses: [String: [String: [String]]] = [:]
    
    init(coursesDict: [String: [String: [String]]]) {
        self.courses = coursesDict
    }
    
    //gets the enrolled courses of the specified student
    func getEnrolledCourses(uid: String) -> [String] {
        var enrolledCourses: [String] = []
        
        //go through each courseId in the course dictionary
        for (courseId, _) in courses {
            enrolledCourses.append(courseId)
        }
        
        return enrolledCourses
    }
    
    //gets the groups the user is in
    func getUsersGroups(uid: String, courseId: String) -> [String] {
        var userGroups: [String] = []
        
        //grab user groups of the specified course
        if let course = self.courses[courseId] {
            if let groups = course[GROUPS_KEY] {
                userGroups = groups
            }
        }
        
        return userGroups
    }
    
    //gets the chats the user is in
    func getUsersChats(uid: String, courseId: String) -> [String] {
        var userChats: [String] = []
        
        //grab user chats of specified course if exists
        if let course = self.courses[courseId] {
            if let chats = course[CHATS_KEY] {
                userChats = chats
            }
        }
        
        return userChats
    }
    
    //enrolls the user in a course
    func enrollUserInCourse(uid: String, courseId: String) {
        if self.courses[courseId] == nil {
            courses[courseId] = [:]
        }
    }
    
    //adds a user to a group within a course
    func addUserToGroup(uid: String, courseId: String, groupId: String) {
        //check to see if course exists
        if let course = self.courses[courseId] {
            //check to see if groups key exists
            if course[GROUPS_KEY] != nil {
                //check if group is already there
                if !self.courses[courseId]![GROUPS_KEY]!.contains(groupId) {
                    self.courses[courseId]![GROUPS_KEY]!.append(groupId)
                }
            }
            //if there is no group key
            else {
                self.courses[courseId]![GROUPS_KEY] = [groupId]
            }
        }
    }
    
    //adds a user to a chat in a course
    func addUserToChat(uid: String, courseId: String, chatId: String) {
        //check to see if course exists
        if let course = self.courses[courseId] {
            //check to see if chats key exists
            if course[CHATS_KEY] != nil {
                //check if chat is already there
                if !self.courses[courseId]![CHATS_KEY]!.contains(chatId) {
                    self.courses[courseId]![CHATS_KEY]!.append(chatId)
                }
            }
            //if theres no chat key
            else {
                self.courses[courseId]![CHATS_KEY] = [chatId]
            }
        }
    }
}