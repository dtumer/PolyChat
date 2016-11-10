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
    
    fileprivate class func getChatRoomsUsersService(_ serviceKey: String) -> ChatRoomsUsersServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseChatRoomsUsersService()
        default:
            return FirebaseChatRoomsUsersService()
        }
    }
}
