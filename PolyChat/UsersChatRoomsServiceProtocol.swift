//
//  UsersChatRoomsServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol UsersChatRoomsServiceProtocol {
    
    /*
     * Adds a reference to the USERS_CHATROOMS table that links a user to a chat room
     *
     * @param userId        - The ID of the user to add to the chat room
     * @param chatRoomId    - The ID of the chat room to add the specified user to
     * @param callback      - The callback function. Called with an error if there is one
     */
    func addUserChatRoomReference(_ userId: String, chatRoomId: String, callback: @escaping (NSError?) -> ())
    
    /*
     * Removes a reference in USERS_CHATROOMS table that links the specified user to the specified chat room
     *
     * @param userId        - The ID of the user to remove from the chat room
     * @param chatRoomId    - The ID of the chat room to remove the specified user from
     * @param callback      - The callback function. Called with an error if there is one
     *
     * NOTE: MAKE SURE TO CALL SUBSEQUENT FUNCTION IN ChatRoomsUsersService AS WELL
     */
    func removeUserChatRoomReference(_ userId: String, chatRoomId: String, callback: @escaping (NSError?) -> ())
}
