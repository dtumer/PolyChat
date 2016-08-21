//
//  ChatRoomsMessagesServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol ChatRoomsMessagesServiceProtocol {
    func getAllMessagesInChatRoom(chatRoomsId: String, callback: (Message?, NSError?) -> ())
    func addMessageToChatRoom(chatRoomId: String, message: Message, callback: (NSError?) -> ())
}