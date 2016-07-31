//
//  CoursesChatRoomsServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol CoursesChatRoomsServiceProtocol {
    //gets the chat rooms for a course
    func getChatRooms(courseId: String, callback: ([ChatRoom]?, NSError?) ->())
    
    //adds a chat room to the respective course
    func addChatRoom(courseId: String, chatRoom: ChatRoom, callback: (NSError?) -> ())
}