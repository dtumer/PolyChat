//
//  MockCoursesChatRoomsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockCoursesChatRoomsService: CoursesChatRoomsServiceProtocol {
    
    //adds reference to chat room in the COURSES_CHATROOMS table
    func addChatRoomReference(courseId: String, chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        
    }
}
