//
//  ChatRoomServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol ChatRoomServiceProtocol {
    
    /*
     * Gets all chat rooms
     *
     * @param callback  - Callback function. Called with the list of all chat rooms or an error if there is one.
     */
    func getAllChatRooms(_ callback: @escaping ([ChatRoom?], NSError?) -> ())
    
    /*
     * Get a specific chat room
     *
     * @param chatRoomId    - The ID of the chat room to get
     * @param callback      - Callback function. Called with the chat room in the database or an error if there is one.
     */
    func getChatRoom(_ chatRoomId: String, callback: @escaping (ChatRoom?, NSError?) -> ())
    
    /*
     * Add a chat room to the CHAT_ROOMS table
     *
     * @param chatRoom  - The chat room to add to the DB
     * @param callback  - The callback function. Called with the ID of the chatroom in the DB or an error if there is one.
     */
    func addChatRoom(_ chatRoom: ChatRoom, callback: @escaping (String?, NSError?) -> ())
    
    /*
     * Updates a chat room
     *
     * @param chatRoomId    - The chat room id of the room to update
     * @param chatRoom      - The chat room obj to put there
     */
    func updateChatRoom(chatRoomId: String, chatRoom: ChatRoom, callback: @escaping (NSError?) -> ())
    
    /* 
     * -----------------------------------
     * COMPOSITE DATABASE ACCESS FUNCTIONS
     * -----------------------------------
     */
    
    /*
     * Get all chat rooms in a course that a given user is in
     *
     * @param courseId  - The course ID of the specific course we are looking in
     * @param userId    - The user ID of the user we are finding chat rooms for
     * @param callback  - The callback function. Called with the list of chat rooms from the DB or an error if there is one
     */
    func getChatRoomsInCourseWithUser(_ courseId: String, userId: String, callback: @escaping ([ChatRoom]?, NSError?) -> ())
    
    /*
     * Creates a chat room and adds it to the appropriate tables
     *
     * @param courseId  - The course this chat room is being added to
     * @param users     - The list of users being added to the chat room
     * @param chatRoom  - The chat room object to be added to the CHATROOMS table
     * @param callback  - The callback function. Called with an error if there is one.
     */
    func createChatRoom(_ courseId: String, users: [User], chatRoom: ChatRoom, callback: @escaping (ChatRoom?, NSError?) -> ())
    
    /*
     * Gets all the users that are in the specified chat room
     *
     * @param chatRoomId    - The id of the chat room to get the users for
     */
    func getAllUsersInAChatRoom(_ chatRoomId: String, callback: @escaping ([User]?, NSError?) -> ())
    
    /*
     * Remove user from chat room
     *
     * @param chatRoomId    - Id of the chat room to remove the user from
     * @param uId           - Id of the user to remove
     * @param users         - user ids of all the users in the room
     * @param callback      - callback function
     */
    func removeUserFromChatRoom(_ chatRoomId: String, uid: String, users: [String], callback: @escaping (NSError?) -> ())
    
    /*
     * adds a user to a chat room
     *
     * @param chatRoomId    - Id of the chat room
     * @param uid           - Id of the user to add
     * @param callback      - callback function
     */
    func addUsersToChatRoom(chatRoomId: String, users: [User], callback: @escaping (NSError?) -> ())
}
