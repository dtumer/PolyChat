//
//  ChatRoomsUsersServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol ChatRoomsUsersServiceProtocol {
    /*
     * Adds a reference to the users in the specific chat rooms
     *
     * @param chatRoomId    - The ID of the chat room to add the reference to
     * @param users         - The list of users to add references to in the chat room
     * @param callback      - The callback function. Called with an error if there is one
     */
    func addChatRoomsUsersReference(chatRoomId: String, users: [User], callback: (NSError?) ->())
    
    /*
     * Removes reference to users in the chat room
     *
     * @param chatRoomId    - The ID of the chat room to remove the reference from
     * @param users         - The list of users to remove references from in the chat room
     * @param callback      - The callback function. Called with an error if there is one
     */
}
