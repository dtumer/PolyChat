//
//  CoursesGroupsServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol CoursesGroupsServiceProtocol {
    /*
     * Adds a reference to the chat room in the COURSES_GROUPS table
     *
     * @param courseId  - The ID of the course to add the reference to
     * @param group  - The group object to be added as a reference to the table
     * @param callback  - The callback function. Called with an error if there is one.
     */
    func addGroupReference(_ courseId: String, group: Group, callback: @escaping (NSError?) -> ())
}
