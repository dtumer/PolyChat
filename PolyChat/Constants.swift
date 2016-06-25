//
//  Constants.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

/*
 * This struct contains constants that are to be used in other areas of the application.
*/
struct Constants {
    //service keys for which server/database services to use in-app
    static let CURRENT_SERVICE_KEY: String = Constants.FIREBASE_SERVICE_KEY
    static let FIREBASE_SERVICE_KEY: String = "firebase"
    //static let MYSQL_SERVICE_KEY: String = "mysql"
    
    
    //colors
    
    //database keys
    static let idKey = "id"
    
    static let usersDBKey = "USERS" //specifies objects in database that contain USER information
    static let roomsDBKey = "ROOMS" //specifies objects in database that contain ROOM information
    static let chatsDBKey = "CHATS" //specifies objects in database that contain CHAT information
    
    //TableViewController Reuse Identifiers
    static let coursesReuseId = "CourseCell"
}