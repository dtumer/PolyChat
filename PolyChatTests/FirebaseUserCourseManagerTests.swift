//
//  UserCourseManagerTest.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import XCTest

class FirebaseUserCourseManagerTests: XCTestCase {
    var coursesDict = [
        "course1": [
            "groups": [
                "group1",
                "group2",
                "group3"
            ],
            "chats": [
                "chat1",
                "chat2",
                "chat3"
            ]
        ],
        "course2": [
            "groups": [
                "group4",
                "group5",
                "group6"
            ],
            "chats": [
                "chat3",
                "chat4",
                "chat5"
            ]
        ]
    ]
    
    var courseManager: FirebaseUserCourseManager!
    
    override func setUp() {
        self.courseManager = FirebaseUserCourseManager(coursesDict: coursesDict)
    }
    
    //tests whether or not the creation of a course manager worked
    func testUserCourseManagerCreation() {
        XCTAssertNotNil(courseManager.courses)
    }
    
    //tests whether or not getting enrolled courses worked
    func testGetEnrolledCourses() {
        let courses = courseManager.getEnrolledCourses(FirebaseUserCourseManager.FAKE_UID)
        
        XCTAssertEqual(courses.count, 2)
    }
    
    //tests whether or not getting groups works
    func testGetParticipatingGroups() {
        let groups1 = courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "course1")
        
        XCTAssertEqual(groups1.count, 3)
    }
    
    //tests getting groups of a non-existent course
    func testGetParticipatingGroupsNoCourse() {
        let groups1 = courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "blah")
        
        XCTAssertNotNil(groups1)
        XCTAssertEqual(groups1.count, 0)
    }
    
    //tests getting chats
    func testGetParticipatingChats() {
        let chats = courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "course2")
        
        XCTAssertEqual(chats.count, 3)
    }
    
    //tests getting chats of non-existent course
    func testGetParticipatingChatsNonExistent() {
        let chats = courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "courseeee")
    
        XCTAssertNotNil(chats)
        XCTAssertEqual(chats.count, 0)
    }
    
    //tests getting all of the above on empty data
    func testGetOnEmptyCourseData() {
        let emptyCourses: [String: [String: [String]]] = [:]
        courseManager = FirebaseUserCourseManager(coursesDict: emptyCourses)
        
        //test courses get
        let courses = courseManager.getEnrolledCourses(FirebaseUserCourseManager.FAKE_UID)
        XCTAssertNotNil(courses)
        XCTAssertEqual(courses.count, 0)
        
        //test groups get
        let groups = courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "aljshdas")
        XCTAssertNotNil(groups)
        XCTAssertEqual(groups.count, 0)
        
        //test chats get
        let chats = courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "lasdhas")
        XCTAssertNotNil(chats)
        XCTAssertEqual(chats.count, 0)
    }
    
    //tests get chats with no "chats" key
    func testGetWithEmptyChatData() {
        let courses: [String: [String: [String]]] = [
            "course1": [:]
        ]
        courseManager = FirebaseUserCourseManager(coursesDict: courses)
        
        let chats = courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "course1")
        XCTAssertNotNil(chats)
        XCTAssertEqual(chats.count, 0)
    }
    
    //tests get groups with no "groups" key
    func testGetWithEmptyGroupData() {
        let courses: [String: [String: [String]]] = [
            "course1": [
                "chats": []
            ]
        ]
        courseManager = FirebaseUserCourseManager(coursesDict: courses)
        
        let groups = courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "course1")
        XCTAssertNotNil(groups)
        XCTAssertEqual(groups.count, 0)
    }
    
    /* MUTATOR TESTS */
    
    //test adding course that is not in the list
    func testAddCourse() {
        courseManager.enrollUserInCourse(FirebaseUserCourseManager.FAKE_UID, courseId: "course3")
        
        XCTAssertEqual(courseManager.courses.count, 3)
    }
    
    //test adding course that IS in list
    func testAddDuplicateCourse() {
        courseManager.enrollUserInCourse(FirebaseUserCourseManager.FAKE_UID, courseId: "course2")
        
        //SHOULD NOT ADD COURSE
        XCTAssertEqual(courseManager.courses.count, 2)
    }
    
    //test adding user to group not in list
    func testAddGroup() {
        courseManager.addUserToGroup(FirebaseUserCourseManager.FAKE_UID, courseId: "course1", groupId: "group5")
        
        XCTAssertEqual(courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 4)
    }
    
    //test adding group already in list
    func testAddDuplicateGroup() {
        courseManager.addUserToGroup(FirebaseUserCourseManager.FAKE_UID, courseId: "course1", groupId: "group1")
        
        //SHOULD NOT ADD
        XCTAssertEqual(courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 3)
    }
    
    //test adding to a group when there's no group key
    func testAddingWhenNoGroupKey() {
        let courses: [String: [String: [String]]] = [
            "course1": [:]
        ]
        courseManager = FirebaseUserCourseManager(coursesDict: courses)
        
        courseManager.addUserToGroup(FirebaseUserCourseManager.FAKE_UID, courseId: "course1", groupId: "group1")
        
        XCTAssertEqual(courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 1)
    }
    
    //test adding groups to non-existent course
    func testAddingGroupToNilCourse() {
        courseManager.addUserToGroup(FirebaseUserCourseManager.FAKE_UID, courseId: "course3", groupId: "asihlkda")
        
        XCTAssertEqual(courseManager.courses.count, 2)
        XCTAssertEqual(courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 3)
        XCTAssertEqual(courseManager.getUsersGroups(FirebaseUserCourseManager.FAKE_UID, courseId: "course2").count, 3)
    }
    
    //test adding user to chat not in list
    func testAddChat() {
        courseManager.addUserToChat(FirebaseUserCourseManager.FAKE_UID, courseId: "course1", chatId: "chat4")
        
        XCTAssertEqual(courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 4)
    }
    
    //test adding chat already in list
    func testAddDuplicateChat() {
        courseManager.addUserToChat(FirebaseUserCourseManager.FAKE_UID, courseId: "course1", chatId: "chat1")
        
        //SHOULD NOT ADD
        XCTAssertEqual(courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 3)
    }
    
    //test adding to a chat when there's no group key
    func testAddingWhenNoChatKey() {
        let courses: [String: [String: [String]]] = [
            "course1": [:]
        ]
        courseManager = FirebaseUserCourseManager(coursesDict: courses)
        
        courseManager.addUserToChat(FirebaseUserCourseManager.FAKE_UID, courseId: "course1", chatId: "chat1")
        
        XCTAssertEqual(courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 1)
    }
    
    //test adding chats to non-existent course
    func testAddingChatToNilCourse() {
        courseManager.addUserToChat(FirebaseUserCourseManager.FAKE_UID, courseId: "course3", chatId: "asihlkda")
        
        XCTAssertEqual(courseManager.courses.count, 2)
        XCTAssertEqual(courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "course1").count, 3)
        XCTAssertEqual(courseManager.getUsersChats(FirebaseUserCourseManager.FAKE_UID, courseId: "course2").count, 3)
    }
}