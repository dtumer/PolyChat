//
//  FirebaseCoursesChatRoomsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseCoursesChatRoomsService: FirebaseDatabaseService, CoursesChatRoomsServiceProtocol {
    func getChatRooms(courseId: String, callback: ([ChatRoom]?, NSError?) -> ()) {
        
    }
    
    func addChatRoom(courseId: String, chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        dbRef.child(Constants.coursesChatRoomsDBKey).child(courseId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? [ChatRoom] {
                print("HEREHEHEHE")
            }
        })
    }
}