//
//  ChatRoomsUsersServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol ChatRoomsUsersServiceProtocol {
    //get all users in a chat room
    func getAllUsersInChatRoom(chatRoomsId: String, callback: ([User]?, NSError?) -> ())
    
    //adds users to chat room
    func addUsersToChatRoom(chatRoomId: String, users: [User], callback: (NSError?) -> ())
}