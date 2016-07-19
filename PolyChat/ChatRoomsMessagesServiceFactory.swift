//
//  ChatRoomsMessagesServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class ChatRoomsMessagesServiceFactory {
    class func getChatRoomsMessagesService(serviceKey: String) -> ChatRoomsMessagesServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseChatRoomsMessagesService()
        default:
            return MockChatRoomsMessagesService()
        }
    }
}