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
    
    
    /*
     * -----------------------------------
     * COMPOSITE DATABASE ACCESS FUNCTIONS
     * -----------------------------------
     */
    
    
    /*
     * Gets all courses that a user is enrolled in
     *
     * @param userId    - The ID of the user to get enrolled courses for
     * @param callback  - The callback function. Called with the list of courses or an error if there was one
     */
    func getCoursesUserIsEnrolledIn(userId: String, callback: ([Course]?, NSError?) -> ())
    
    /*
     * Enrolls a user in a course
     *
     * @param userId    - The ID of the student to enroll in a course
     * @param courseId  - The ID of the course to enroll the student in
     * @param callback  - The callback function. Called with an error if there is one
     */
    func enrollStudentInCourse(userId: String, courseId: String, callback: (NSError?) -> ())
}
