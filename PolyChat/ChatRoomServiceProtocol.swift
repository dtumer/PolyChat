//
//  ChatRoomServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol ChatRoomServiceProtocol {
    //get chat room by id
    func getChatRoom(chatRoomId: String, callback: (ChatRoom?, NSError?) -> ())
    
    //creates a chat room
    func createChatRoom(courseId: String, users: [User], chatRoom: ChatRoom, callback: (NSError?) -> ())
}