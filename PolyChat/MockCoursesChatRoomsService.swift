//
//  MockCoursesChatRoomsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockCoursesChatRoomsService: CoursesChatRoomsServiceProtocol {
    func getChatRooms(courseId: String, callback: ([ChatRoom]?, NSError?) -> ()) {
        
    }
    
    func addChatRoom(courseId: String, chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        
    }
}