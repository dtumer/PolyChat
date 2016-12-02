//
//  MessageServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol MessageServiceProtocol {
    /*
     * Gets a message from the MESSAGES table
     *
     * @param messageId - The ID of the message to get
     * @param callback  - The callback function. Called with the message or an error if there is one
     */
    func getMessage(_ messageId: String, callback: @escaping (Message?, NSError?) -> ())
    
    /*
     * Add message to MESSAGES table
     *
     * @param message
     * @param callback  - The callback function. Called with the key of the message or an error if there is one
     */
    func addMessage(_ message: Message, callback: @escaping (String?, NSError?) -> ())
    
    
    /*
     * -----------------------------------
     * COMPOSITE DATABASE ACCESS FUNCTIONS
     * -----------------------------------
     */
    
    /*
     * Gets all messages in a chat room
     *
     * @param chatRoomId    - The ID of the chat room to get messages from
     * @param callback      - The callback function. Called with the messages or an error if there is one
     */
    func getMessagesInChatRoom(_ chatRoomId: String, last n: Int, addObserver observe: Bool, callback: @escaping (Message?, NSError?) -> ())
    
    
    /*
     * Gets the total number of messages in a chat room
     *
     * @param chatRoomId    - The ID of the chat room to get messages from
     * @param callback      - The callback function. Called with the message count or an error if there is one
     */
    func getNumMessagesInChatRoom(_ chatRoomId: String, callback: @escaping (Int?, NSError?) -> ())
    
    /*
     * Adds a message to the chat room
     *
     * @param chatRoomId    - The ID of the chat room to add the message to
     * @param message       - The message object of the message to be added
     * @param callback      - The callback function. Called with and error if there is one
     */
    func addMessageToChatRoom(_ chatRoomId: String, message: Message, callback: @escaping (NSError?) -> ())
}
