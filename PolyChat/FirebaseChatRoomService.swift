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
    
    let coursesChatRoomsService = CoursesChatRoomsServiceFactory.sharedInstance
    let usersChatRoomsService = UsersChatRoomsServiceFactory.sharedInstance
    let chatRoomsUsersService = ChatRoomsUsersServiceFactory.sharedInstance
    
    //get all chat rooms
    func getAllChatRooms(callback: ([ChatRoom?], NSError?) -> ()) {
        //TODO finish this eventually
    }
    
    //get a chat room
    func getChatRoom(chatRoomId: String, callback: (ChatRoom?, NSError?) -> ()) {
        dbRef.child(Constants.chatRoomsDBKey).child(chatRoomId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? NSMutableDictionary {
                value["id"] = chatRoomId
                
                callback(ChatRoom(dictionary: value), nil)
            }
            else {
                callback(nil, NSError(domain: "\(self.DOMAIN)getChatRoom", code: 0, description: "Error value is either no existent or is not a dictionary"))
            }
        })
    }
    
    //add a chat room
    func addChatRoom(chatRoom: ChatRoom, callback: (String?, NSError?) -> ()) {
        let key = getAutoId(Constants.chatRoomsDBKey)
        let childUpdates = [
            "/\(Constants.chatRoomsDBKey)/\(key)": chatRoom.toDictionary()
        ]
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(nil, error)
            }
            else {
                callback(key, nil)
            }
        })
    }
}

/* COMPOSITE FUNCTIONS */
extension FirebaseChatRoomService {
    //gets all chat rooms in a course that a user is a part of
    func getChatRoomsInCourseWithUser(courseId: String, userId: String, callback: ([ChatRoom]?, NSError?) -> ()) {
        var chatRooms: [ChatRoom] = []
        var numChatRooms = 0
        
        //1: Get all chat rooms a user is in
        dbRef.child(Constants.usersChatRoomsDBKey).child(userId).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let chatRoomArr = snapshot.value as? NSArray {
                //Get all chat rooms in a course
                self.dbRef.child(Constants.coursesChatRoomsDBKey).child(courseId).observeSingleEventOfType(.Value, withBlock: { snapshot in
                    //check if the course has any chat rooms
                    if let chatRoomCourseArr = snapshot.value as? NSArray {
                        //go through each chat room id and check if it's in the course
                        for crId in chatRoomArr {
                            //if the chat room is in the course return it, or an error if there was one
                            if chatRoomCourseArr.indexOfObject(crId) >= 0 {
                                self.getChatRoom(crId as! String, callback: { (chatRoom, error) in
                                    if let error = error {
                                        callback(nil, error)
                                        return
                                    }
                                    else {
                                        chatRooms.append(chatRoom!)
                                        numChatRooms += 1
                                    }
                                    
                                    //only callback with everything if we've processed everything correctly
                                    if numChatRooms == chatRoomArr.count {
                                        callback(chatRooms, nil)
                                    }
                                })
                            }
                        }
                    }
                    else {
                        let error = NSError(domain: "\(self.DOMAIN)getChatRoomsInCourseWithUser", code: 0, description: "Value in COURSES_CHATROOMS is not of type NSArray")
                        callback(nil, error)
                    }
                })
            }
            else {
                let error = NSError(domain: "\(self.DOMAIN)getChatRoomsInCourseWithUser", code: 0, description: "Value in USERS_CHATROOMS is not of type NSArray")
                callback(nil, error)
            }
        })
    }
    
    //creates a chat room
    func createChatRoom(courseId: String, users: [User], chatRoom: ChatRoom, callback: (NSError?) -> ()) {
        //1: Create chat room
        self.addChatRoom(chatRoom, callback: { (string, error) in
            if let error = error {
                callback(error)
            }
            else if let chatRoomId = string {
                chatRoom.id = chatRoomId
                
                //2: add chat room to COURSES_CHATROOMS
                self.coursesChatRoomsService.addChatRoomReference(courseId, chatRoom: chatRoom, callback: { error in
                    if let error = error {
                        callback(error)
                    }
                    else {
                        //3: Add all users to CHATROOMS_USERS table
                        //TODO change this to new reference function
                        self.chatRoomsUsersService.addChatRoomsUsersReference(chatRoom.id, users: users, callback: { error in
                            if let error = error {
                                callback(error)
                            }
                            else {
                                //4: For each user add their reference in the USERS_CHATROOMS table
                                for user in users {
                                    self.usersChatRoomsService.addUserChatRoomReference(user.id, chatRoomId: chatRoom.id, callback: { error in
                                        if let error = error {
                                            callback(error)
                                        }
                                        else {
                                            callback(nil)
                                        }
                                    })
                                }
                            }
                        })
                    }
                })
            }
        })
    }
}