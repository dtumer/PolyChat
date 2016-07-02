//
//  FirebaseChatRoomService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseChatRoomService: ChatRoomServiceProtocol {
    let userService = UserServiceFactory.getUserService(Constants.FIREBASE_SERVICE_KEY)
    let chatRoomRef = FIRDatabase.database().reference()
    
    func getRoomsWithUser(uid: String, completion: (NSArray?, NSError?) -> ()) {
        //1: Get rooms that user is in from the Users table
        //2: Loop through that list and retrieve each room in the Rooms table
        //3: Add them all to a list and do the callback
    }
}