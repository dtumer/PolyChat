//
//  CoursesChatRoomsServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol CoursesChatRoomsServiceProtocol {
    /*
     * Adds a reference to the chat room in the COURSES_CHATROOMS table
     *
     * @param courseId  - The ID of the course to add the reference to
     * @param chatRoom  - The chat room object to be added as a reference to the table
     * @param callback  - The callback function. Called with an error if there is one.
     */
    func addChatRoomReference(courseId: String, chatRoom: ChatRoom, callback: (NSError?) -> ())
}
