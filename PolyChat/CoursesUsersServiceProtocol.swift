//
//  CoursesUsersServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol CoursesUsersServiceProtocol {
    //adds a user to a course
    //TODO change the name of this function and implement it
    func enrollUserInCourse(courseId: String, userId: String, callback: (NSError?) -> ())
}
