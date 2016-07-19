//
//  MessagesServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class MessageServiceFactory {
    class func getMessageService(serviceKey: String) -> MessageServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseMessageService()
        default:
            return MockMessageService()
        }
    }
}