//
//  ChatRoomServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class ChatRoomServiceFactory {
    class func getChatRoomService(serviceKey: String) -> ChatRoomServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseChatService()
        default:
            return MockChatService()
        }
    }
}