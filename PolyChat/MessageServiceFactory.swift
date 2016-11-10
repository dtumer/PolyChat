//
//  MessagesServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class MessageServiceFactory {
    class var sharedInstance: MessageServiceProtocol! {
        struct Singleton {
            static let instance = MessageServiceFactory.getMessageService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getMessageService(_ serviceKey: String) -> MessageServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseMessageService()
        default:
            return FirebaseMessageService()
        }
    }
}
