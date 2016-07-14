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
        let email = "dtumer@calpoly.edu"
        let userDict = [
            "email": email,
            "name": GlobalUtilities.getNameFromEmail(email)
        ]
        
        let user1 = User(dictionary: userDict)
        
        XCTAssertEqual(user1.email, "dtumer@calpoly.edu")
        XCTAssertEqual(user1.name, "dtumer")
    }
}
