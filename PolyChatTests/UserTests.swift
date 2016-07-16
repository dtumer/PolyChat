//
//  UserTests.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import XCTest

class UserTests: XCTestCase {
    var userDict: NSMutableDictionary = [
        "id": "12345",
        "name": "dtumer",
        "email": "dtumer@calpoly.edu",
        "role": Constants.USER_DEFAULT,
        "user_image_link": ""
    ]
    var user: User!
    
    //called every function
    override func setUp() {
        user = User(dictionary: userDict)
    }
    
    //test regular user creation
    func testUserCreation() {
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, "12345")
        XCTAssertEqual(user.name, "dtumer")
        XCTAssertEqual(user.email, "dtumer@calpoly.edu")
        XCTAssertEqual(user.role, Constants.USER_DEFAULT)
        XCTAssertEqual(user.userImageLink, "")
    }
    
    //test user creation empty user
    func testEmptyUserCreation() {
        let userDict: NSDictionary = [:]
        user = User(dictionary: userDict)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, "")
        XCTAssertEqual(user.name, "")
        XCTAssertEqual(user.email, "")
        XCTAssertEqual(user.role, Constants.USER_DEFAULT)
        XCTAssertEqual(user.userImageLink, "")
    }
    
    //test user creation with some missing things
    func testMissingUserCreation() {
        let userDict: NSDictionary = [
            "id": "1234",
            "email": "dtumer@calpoly.edu"
        ]
        user = User(dictionary: userDict)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, "1234")
        XCTAssertEqual(user.name, "")
        XCTAssertEqual(user.email, "dtumer@calpoly.edu")
        XCTAssertEqual(user.role, Constants.USER_DEFAULT)
        XCTAssertEqual(user.userImageLink, "")
    }
    
    //test user creation with invalid data
    func testInvalidUserCreation() {
        let userDict: NSDictionary = [
            "id": 1234,
            "email": "alklkjsadlks",
            "hello": "there"
        ]
        user = User(dictionary: userDict)
        
        XCTAssertNotNil(user)
        XCTAssertEqual(user.id, "1234")
        XCTAssertEqual(user.name, "")
        XCTAssertEqual(user.email, "alklkjsadlks")
        XCTAssertEqual(user.role, Constants.USER_DEFAULT)
        XCTAssertEqual(user.userImageLink, "")
    }
    
    //test user converted to dictionary
    func testUserToDictionary() {
        let userDict = user.toDictionary()
        self.userDict["courses"] = [:]
        
        XCTAssertNotNil(userDict)
        XCTAssertEqual(self.userDict, userDict)
    }
}
