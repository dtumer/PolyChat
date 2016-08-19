//
//  ChatRoomServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class ChatRoomServiceFactory {
    class var sharedInstance: ChatRoomServiceProtocol! {
        struct Singleton {
            static let instance = ChatRoomServiceFactory.getChatRoomService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    private class func getChatRoomService(serviceKey: String) -> ChatRoomServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseChatRoomService()
        default:
            return MockChatRoomService()
        }
    }
}