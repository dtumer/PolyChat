//
//  FirebaseCoursesChatRoomsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseCoursesChatRoomsService: FirebaseDatabaseService, CoursesChatRoomsServiceProtocol {
    let DOMAIN = "FirebaseCoursesChatRoomsServices::"
    
    //add reference to chat room in COURSES_CHATROOMS
    func addChatRoomReference(_ courseId: String, chatRoom: ChatRoom, callback: @escaping (NSError?) -> ()) {
        self.getChatRoomsIds(courseId, callback: { (courseIds, error) in
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
            ids.append(chatRoom.id)
            let childUpdates = ["\(Constants.coursesChatRoomsDBKey)/\(courseId)": ids]
            
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
    
    //gets all the ids of the chat rooms
    func getChatRoomsIds(_ courseId: String, callback: @escaping ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.coursesChatRoomsDBKey).child(courseId).observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getChatRoomIds", code: 0, description: "error value is null"))
            }
        })
    }
}
