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
    
    let chatRoomService = ChatRoomServiceFactory.getChatRoomService(Constants.CURRENT_SERVICE_KEY)
    let coursesChatRoomsService = CoursesChatRoomsFactory.getCoursesChatRoomsService(Constants.CURRENT_SERVICE_KEY)
    let chatRoomsUsersService = ChatRoomsUsersServiceFactory.getChatRoomsUsersService(Constants.CURRENT_SERVICE_KEY)
    
    func createChatRoom(courseId: String, users: [User], chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        //1: Add chat room to CHATROOMS table
        let key = getAutoId(Constants.chatRoomsDBKey)
        let childUpdates = ["/\(Constants.chatRoomsDBKey)/\(key)": chatRoom.toDictionary()]
        
        //set the id of the chat room
        chatRoom.id = key
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
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
                            self.addUserToChatRoom(user.id, chatRoomId: chatRoom.id, callback: { error in
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
                            else {
                                callback(nil)
                            }
                        })
                    }
                })
            }
        })
    }
    
    func getChatRoomsByUser(userId: String, callback: ([ChatRoom]?, NSError?) -> ()) {
        dbRef.child(Constants.usersChatRoomsDBKey).child(userId).observeSingleEventOfType(.Value, withBlock: {
            snapshot in

            if let chatRoomsArr = snapshot.value as? NSArray {
                for crId in chatRoomsArr {
                    if let crId = crId as? String {
                        self.chatRoomService.getChatRoom(crId, callback: { (chatRoom, error) in
                            if let error = error {
                                callback(nil, error)
                                return
                            }
                            else {
                                callback([chatRoom!], nil)
                            }
                        })
                    }
                    else {
                        let error = NSError(domain: "\(self.DOMAIN)getChatRoomsByUser", code: 1, description: "ChatRoom id for some reason is not a String")
                        callback(nil, error)
                        return
                    }
                }
            }
            else {
                let error = NSError(domain: "\(self.DOMAIN)getChatRoomsByUser", code: 1, description: "Value in DB is not of type NSArray")
                callback(nil, error)
                return
            }
        })
    }
    
    //adds user to a chatroom
    func addUserToChatRoom(userId: String, chatRoomId: String, callback: (NSError?) -> ()) {
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
                    callback(error)
                }
                else {
                    callback(nil)
                }
            })
        })
    }
    
    //gets list of chat room ids
    func getChatRoomIds(userId: String, callback: ([String]?, NSError?) -> ()) {
        dbRef.child(Constants.usersChatRoomsDBKey).child(userId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let val = snapshot.value as? [String] {
                callback(val, nil)
            }
            else if let _ = snapshot.value as? NSNull {
                callback(nil, NSError(domain: "\(self.DOMAIN)getChatRoomIds", code: 0, description: "error there is no values in the db"))
            }
        })
    }
}