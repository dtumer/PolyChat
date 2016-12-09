//
//  FirebaseChatRoomService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class FirebaseChatRoomService: FirebaseDatabaseService, ChatRoomServiceProtocol {
    let DOMAIN = "FirebaseChatRoomService::"
    
    let coursesChatRoomsService = CoursesChatRoomsServiceFactory.sharedInstance
    let usersChatRoomsService = UsersChatRoomsServiceFactory.sharedInstance
    let chatRoomsUsersService = ChatRoomsUsersServiceFactory.sharedInstance
    let userService = UserServiceFactory.sharedInstance
    
    //get all chat rooms
    func getAllChatRooms(_ callback: @escaping ([ChatRoom?], NSError?) -> ()) {
        //TODO finish this eventually
    }
    
    //get a chat room
    func getChatRoom(_ chatRoomId: String, callback: @escaping (ChatRoom?, NSError?) -> ()) {
        dbRef.child(Constants.chatRoomsDBKey).child(chatRoomId).observeSingleEvent(of: .value, with: { snapshot in
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
    func addChatRoom(_ chatRoom: ChatRoom, callback: @escaping (String?, NSError?) -> ()) {
        let key = getAutoId(Constants.chatRoomsDBKey)
        let childUpdates = [
            "/\(Constants.chatRoomsDBKey)/\(key)": chatRoom.toDictionary()
        ]
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(nil, error as NSError?)
            }
            else {
                callback(key, nil)
            }
        })
    }
    
    //updates a chat room
    func updateChatRoom(chatRoomId: String, chatRoom: ChatRoom, callback: @escaping (NSError?) -> ()) {
        let childUpdates = [
            "/\(Constants.chatRoomsDBKey)/\(chatRoomId)": chatRoom.toDictionary()
        ]
        
        dbRef.updateChildValues(childUpdates, withCompletionBlock: { (error, ref) in
            if let error = error {
                callback(error as NSError?)
            }
            else {
                callback(nil)
            }
        })
    }
}

/* COMPOSITE FUNCTIONS */
extension FirebaseChatRoomService {
    //gets all chat rooms in a course that a user is a part of
    func getChatRoomsInCourseWithUser(_ courseId: String, userId: String, callback: @escaping ([ChatRoom]?, NSError?) -> ()) {
        var chatRooms: [ChatRoom] = []
        var numChatRooms = 0
        
        //1: Get all chat rooms a user is in
        dbRef.child(Constants.usersChatRoomsDBKey).child(userId).observeSingleEvent(of: .value, with: { snapshot in
            if let chatRoomArr = snapshot.value as? NSArray {
                //Get all chat rooms in a course
                self.dbRef.child(Constants.coursesChatRoomsDBKey).child(courseId).observeSingleEvent(of: .value, with: { snapshot in
                    //check if the course has any chat rooms
                    if let chatRoomCourseArr = snapshot.value as? NSArray {
                        //go through each chat room id and check if it's in the course
                        for crId in chatRoomArr {
                            //if the chat room is in the course return it, or an error if there was one
                            if chatRoomCourseArr.index(of: crId) >= 0 {
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
                        let error = NSError(domain: "\(self.DOMAIN)getChatRoomsInCourseWithUser", code: 1, description: "Value in COURSES_CHATROOMS is not of type NSArray")
                        callback(nil, error)
                    }
                })
            }
            else {
                let error = NSError(domain: "\(self.DOMAIN)getChatRoomsInCourseWithUser", code: 1, description: "Value in USERS_CHATROOMS is not of type NSArray")
                callback(nil, error)
            }
        })
    }
    
    //creates a chat room
    func createChatRoom(_ courseId: String, users: [User], chatRoom: ChatRoom, callback: @escaping (ChatRoom?, NSError?) -> ()) {
        //1: Create chat room
        self.addChatRoom(chatRoom, callback: { (string, error) in
            if let error = error {
                callback(nil, error)
            }
            else if let chatRoomId = string {
                chatRoom.id = chatRoomId
                
                //2: add chat room to COURSES_CHATROOMS
                self.coursesChatRoomsService?.addChatRoomReference(courseId, chatRoom: chatRoom, callback: { error in
                    if let error = error {
                        callback(nil, error)
                    }
                    else {
                        //3: Add all users to CHATROOMS_USERS table
                        //TODO change this to new reference function
                        self.chatRoomsUsersService?.addChatRoomsUsersReference(chatRoom.id, users: users, callback: { error in
                            if let error = error {
                                callback(nil, error)
                            }
                            else {
                                //4: For each user add their reference in the USERS_CHATROOMS table
                                for user in users {
                                    self.usersChatRoomsService?.addUserChatRoomReference(user.id, chatRoomId: chatRoom.id, callback: { error in
                                        if let error = error {
                                            callback(nil, error)
                                        }
                                        else {
                                            callback(chatRoom, nil)
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
    
    //gets all users in a chatroom
    func getAllUsersInAChatRoom(_ chatRoomId: String, callback: @escaping ([User]?, NSError?) -> ()) {
        var users: [User] = []
        var numUsers = 0
        
        self.chatRoomsUsersService?.getAllReferences(chatRoomId, callback: { (userIds, error) in
            if let error = error {
                callback(nil, error)
            }
            else {
                if let userIds = userIds {
                    for uid in userIds {
                        self.userService?.getUser(uid, callback: { (user, error) in
                            if let error = error {
                                callback(nil, error)
                            }
                            else {
                                users.append(user!)
                                numUsers += 1
                            }
                            
                            //only callback if we've gone through all of them
                            if numUsers == userIds.count {
                                callback(users, nil)
                            }
                        })
                    }
                }
            }
        })
    }
    
    //removes a user from a chat room
    func removeUserFromChatRoom(_ chatRoomId: String, uid: String, users: [String], callback: @escaping (NSError?) -> ()) {
        var newChatRooms: [String] = []
        
        //updates list of users
        self.chatRoomsUsersService?.updateReference(chatRoomId, users: users, callback: { error in
            if let error = error {
                callback(error)
            }
            else {
                //updates user object with new list of chat rooms
                self.usersChatRoomsService?.getChatRoomReferences(uid, callback: { (chatRooms, error) in
                    if let error = error {
                        callback(error)
                    }
                    else {
                        for cId in chatRooms! {
                            if cId != chatRoomId {
                                newChatRooms.append(cId)
                            }
                        }
                        
                        self.usersChatRoomsService?.updateChatRoomReferences(uid, chatRooms: newChatRooms, callback: { error in
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
    
    //adds users to a chat room
    func addUsersToChatRoom(chatRoomId: String, users: [User], callback: @escaping (NSError?) -> ()) {
        self.chatRoomsUsersService?.addChatRoomsUsersReference(chatRoomId, users: users, callback: { error in
            if let error = error {
                callback(error)
            }
            else {
                //4: For each user add their reference in the USERS_CHATROOMS table
                for user in users {
                    self.usersChatRoomsService?.addUserChatRoomReference(user.id, chatRoomId: chatRoomId, callback: { error in
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
}
