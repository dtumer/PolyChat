//
//  CourseServiceProtocol.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol CourseServiceProtocol {
    
    /*
     * Gets a specific course based on the ID
     *
     * @param courseId  - ID of the course to get
     * @param callback  - Callback function. Called with the specified course from the database or an error if there is one. 
     */
    func getCourse(courseId: String, callback: (Course?, NSError?) -> ())
    
    /*
     * Gets all courses from the COURSE table
     *
     * @param callback  - The callback function. Called with the list of courses in the database or an error if there is one.
     */
    func getAllCourses(callback: ([Course]?, NSError?) -> ())
    
    /*
     * Adds a course to the COURSE table
     * 
     * @param course    - The course to be stored
     * @param callback  - The callback function. The callback function is called with the ID of the new database object or an error if there is one
     */
    func addCourse(course: Course, callback: (String?, NSError?) -> ())
    
    /*
     * Removes a course from the COURSE table
     *
     * @param course    - The course to be removed
     * @param callback  - The callback function. Called with an error if there is one.
     */
    func removeCourse(course: Course, callback: (NSError?) -> ())
}
