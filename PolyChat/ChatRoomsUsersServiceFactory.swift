//
//  ChatRoomsUsersServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class ChatRoomsUsersServiceFactory {
    class var sharedInstance: ChatRoomsUsersServiceProtocol! {
        struct Singleton {
            static let instance = ChatRoomsUsersServiceFactory.getChatRoomsUsersService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    private class func getChatRoomsUsersService(serviceKey: String) -> ChatRoomsUsersServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseChatRoomsUsersService()
        default:
            return FirebaseChatRoomsUsersService()
        }
    }
}