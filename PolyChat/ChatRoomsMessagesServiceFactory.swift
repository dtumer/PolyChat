//
//  ChatRoomsMessagesServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class ChatRoomsMessagesServiceFactory {
    class var sharedInstance: ChatRoomsMessagesServiceProtocol! {
        struct Singleton {
            static let instance = ChatRoomsMessagesServiceFactory.getChatRoomsMessagesService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    class func getChatRoomsMessagesService(_ serviceKey: String) -> ChatRoomsMessagesServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseChatRoomsMessagesService()
        default:
            return FirebaseChatRoomsMessagesService()
        }
    }
}
