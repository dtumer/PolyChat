//
//  MyCoursesServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

protocol MyCoursesServiceProtocol {
    func getEnrolledCourses(uid: String, callback: ([Course]?, NSError?) -> ())
}
