//
//  FirebaseUsersChatRoomsService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseUsersChatRoomsService: FirebaseDatabaseService, UsersChatRoomsServiceProtocol {
    let DOMAIN = "FirebaseUsersChatRoomServices::"
    
    //add chat room reference in the USERS_CHATROOMS table
    func addUserChatRoomReference(_ userId: String, chatRoomId: String, callback: @escaping (NSError?) -> ()) {
        self.getChatRoomIds(userId, callback: { (chatrooms, error) in
            var ids: [String] = []
            
            //if there are chatrooms already in the table
            if let chatrooms = chatrooms {
                ids += chatrooms
            }
                //there was an error
            else {
                if error?.code != 0 {
                    callback(error)
                    return
                }
            }
            
            //add id and push to db
            ids.append(chatRoomId)
            let childUpdates = ["\(Constants.usersChatRoomsDBKey)/\(userId)": ids]
            
            self.dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
                if let error = error {
                    callback(error as NSError?)
                }
                else {
                    callback(nil)
                }
            })
        })
    }
    
    //removes chat room reference in the USERS_CHATROOMS table
    func removeUserChatRoomReference(_ userId: String, chatRoomId: String, callback: @escaping (NSError?) -> ()) {
        
    }
    
    //gets list of chat room ids
    func getChatRoomIds(_ userId: String, callback: @escaping ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.usersChatRoomsDBKey).child(userId).observeSingleEvent(of: .value, with: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getChatRoomIds", code: 0, description: "error there is no values in the db"))
            }
        })
    }
}
