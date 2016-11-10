//
//  ChatRoomsMessagesServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol ChatRoomsMessagesServiceProtocol {
    /*
     * Adds reference in the CHATROOMS_MESSAGES table
     *
     * @param chatRoomId    - The ID of the chat room to add the reference to
     * @param messageId     - The ID of the message to be added
     */
    func addChatRoomsMessagesReference(chatRoomId: String, messageId: String, callback: @escaping (NSError?) -> ())
}
