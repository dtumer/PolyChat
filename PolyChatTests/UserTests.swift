//
//  UserTests.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import XCTest

class UserTests: XCTestCase {
    
    func testUserCreation() {
        let courses = [
            "CPE-101-01",
            "CPE-101-02",
            "ENGL-149-02",
            "CPE-141-05"
        ]
        
        let userDict = [
            "email": "dtumer@calpoly.edu",
            "courses": courses
        ]
        
        let user1 = User(dictionary: userDict)
        
        XCTAssertEqual(user1.email, "dtumer@calpoly.edu")
        
        for courseNdx in 0..<user1.courses.count {
            XCTAssertEqual(user1.courses[courseNdx].name, courses[courseNdx])
        }
    }
}
