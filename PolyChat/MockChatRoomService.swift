//
//  MockChatRoomService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockChatRoomService: ChatRoomServiceProtocol {
    //get all chat rooms
    func getAllChatRooms(callback: ([ChatRoom?], NSError?) -> ()) {
        
    }
    
    //get a specific chat room
    func getChatRoom(chatRoomId: String, callback: (ChatRoom?, NSError?) -> ()) {
        
    }
    
    //add a chat room
    func addChatRoom(chatRoom: ChatRoom, callback: (String?, NSError?) -> ()) {
        
    }
}

/* COMPOSITE TABLE FUNCTIONS */
extension MockChatRoomService {
    func getChatRoomsInCourseWithUser(courseId: String, userId: String, callback: ([ChatRoom]?, NSError?) -> ()) {
        
    }
    
    func createChatRoom(courseId: String, users: [User], chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        
    }
}
