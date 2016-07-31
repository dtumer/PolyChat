//
//  FirebaseChatRoomService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseChatRoomService: FirebaseDatabaseService, ChatRoomServiceProtocol {
    let DOMAIN = "FirebaseChatRoomService::"
    let coursesChatRoomsService = CoursesChatRoomsFactory.getCoursesChatRoomsService(Constants.CURRENT_SERVICE_KEY)
    let usersChatRoomsService = UsersChatRoomsServiceFactory.getUsersChatRoomsService(Constants.CURRENT_SERVICE_KEY)
    let chatRoomsUsersService = ChatRoomsUsersServiceFactory.getChatRoomsUsersService(Constants.CURRENT_SERVICE_KEY)
    
    func getChatRoom(chatRoomId: String, callback: (ChatRoom?, NSError?) -> ()) {
        
    }
    
    func getRoomsWithUser(uid: String, completion: (NSArray?, NSError?) -> ()) {
        //1: Get rooms that user is in from the Users table
        //2: Loop through that list and retrieve each room in the Rooms table
        //3: Add them all to a list and do the callback
    }
    
    func createChatRoom(courseId: String, users: [User], chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        //1: Add chat room to CHATROOMS table
        let key = getAutoId(Constants.chatRoomsDBKey)
        let childUpdates = ["/\(Constants.chatRoomsDBKey)/\(key)": chatRoom.toDictionary()]
        
        //set the id of the chat room
        chatRoom.id = key
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                //TODO log better
                callback(error)
            }
            else {
                //2: Add chat room id to COURSES_CHATROOMS table
                self.coursesChatRoomsService.addChatRoom(courseId, chatRoom: chatRoom, callback: { error in
                    if let error = error {
                        callback(error)
                    }
                    else {
                        //3: Add chat room id to USERS_CHATROOMS table for each user in the chat room
                        for user in users {
                            self.usersChatRoomsService.addUserToChatRoom(user.id, chatRoomId: chatRoom.id, callback: { error in
                                if let error = error {
                                    callback(error)
                                }
                            })
                        }
                        
                        //4: Add all users to CHATROOMS_USERS table
                        self.chatRoomsUsersService.addUsersToChatRoom(chatRoom.id, users: users, callback: { error in
                            if let error = error {
                                callback(error)
                            }
                        })
                    }
                })
            }
        })
    }
}