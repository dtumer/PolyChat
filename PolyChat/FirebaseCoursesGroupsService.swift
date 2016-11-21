//
//  FirebaseCoursesGroupsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseCoursesGroupsService: FirebaseDatabaseService, CoursesGroupsServiceProtocol {
    let DOMAIN = "FirebaseCoursesGroupsServices::"
    
    //add reference to chat room in COURSES_GROUPS
    func addGroupReference(_ courseId: String, group: Group, callback: @escaping (NSError?) -> ()) {
        self.getGroupsIds(courseId, callback: { (courseIds, error) in
            var ids: [String] = []
            
            //if there's something there
            if let courseIds = courseIds {
                ids += courseIds
            }
                //means there was an error
            else {
                //if we're dealing with an error that is not a null type
                if error?.code != 0 {
                    callback(error)
                    return
                }
            }
            
            //add the courseId in and write it to db
            ids.append(group.id)
            let childUpdates = ["\(Constants.coursesGroupsDBKey)/\(courseId)": ids]
            
            self.dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
                if let error = error {
                    callback(error as NSError?)
                }
                else {
                    callback(nil)
                }
            })
            
        })
    }
    
    //gets all the ids of the groups
    func getGroupsIds(_ courseId: String, callback: @escaping ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.coursesGroupsDBKey).child(courseId).observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getGroupIds", code: 0, description: "error value is null"))
            }
        })
    }
}
