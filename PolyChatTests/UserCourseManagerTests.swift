//
//  UserCourseManagerTest.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import XCTest

class UserCourseManagerTests: XCTestCase {
    func testUserCourseManagerCreation() {
        let coursesDict = [
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
        
        var coursesManager = UserCourseManager(courses: coursesDict)
        
        XCTAssertNotNil(coursesManager.courses)
    }
}