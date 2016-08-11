//
//  UsersChatRoomsServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol UsersChatRoomsServiceProtocol {
    //gets all chat rooms that a user is in
    func getChatRoomsByUser(userId: String, callback: ([ChatRoom]?, NSError?) -> ())
    
    //adds the user to a chat room
    func addUserToChatRoom(userId: String, chatRoomId: String, callback: (NSError?) -> ())
    
    //creates a chat room
    func createChatRoom(courseId: String, users: [User], chatRoom: ChatRoom, callback: (NSError?) -> ())
}