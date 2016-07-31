//
//  MockChatRoomsUsersService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class MockChatRoomsUsersService: ChatRoomsUsersServiceProtocol {
    func getAllUsersInChatRoom(chatRoomsId: String, callback: ([User]?, NSError?) -> ()) {
        
    }
    
    func addUsersToChatRoom(chatRoomId: String, users: [User], callback: (NSError?) -> ()) {
        
    }
}