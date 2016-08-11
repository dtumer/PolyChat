//
//  MockUsersChatRoomsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockUsersChatRoomsService: UsersChatRoomsServiceProtocol {
    func getChatRoomsByUser(userId: String, callback: ([ChatRoom]?, NSError?) -> ()) {
        
    }
    
    func addUserToChatRoom(userId: String, chatRoomId: String, callback: (NSError?) -> ()) {
        
    }
    
    func createChatRoom(courseId: String, users: [User], chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        
    }
}