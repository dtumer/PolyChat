//
//  Constants.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import XCGLogger

/*
 * This struct contains constants that are to be used in other areas of the application.
*/
struct Constants {
    /* App Constants */
    //app mode
    static let APP_MODE = Constants.APP_DEV
    private static let APP_DEV = XCGLogger.LogLevel.Debug
    private static let APP_PROD = XCGLogger.LogLevel.None
    
    //service keys for which server/database services to use in-app
    static let CURRENT_SERVICE_KEY: String = Constants.FIREBASE_SERVICE_KEY
    static let FIREBASE_SERVICE_KEY: String = "firebase"
    static let MOCK_SERVICE_KEY: String = "mock"
    //static let MYSQL_SERVICE_KEY: String = "mysql"
    
    //database keys
    static let idKey = "id"
    
    //table keys
    static let usersDBKey = "USERS" //specifies objects in db that contain USER data
    static let chatRoomsDBKey = "CHATROOMS" //specifies objects in db that contain CHAT_ROOM data
    static let messagesDBKey = "MESSAGES" //specifies objects in db that contain MESSAGE data
    static let coursesDBKey = "COURSES" // specifies objects in db that contain COURSE data
    static let groupsDBKey = "GROUPS" // specifies object in bd that contain GROUP data
    static let usersGroupsDBKey = "USERS_GROUPS"
    static let usersCoursesDBKey = "USERS_COURSES"
    static let usersChatRoomsDBKey = "USERS_CHATROOMS"
    static let chatRoomsMessagesDBKey = "CHATROOMS_MESSAGES"
    
    //TableViewController Reuse Identifiers
    static let myCoursesReuseId = "MyCourseCell"
    static let coursesReuseId = "CourseCell"
    static let usersAdminReuseId = "UsersAdminCell"
    static let menuReuseId = "MenuCell"
    
    //Segue Identifiers
    static let loginSegueId = "LoginSegue"
    
    /* Model Constants */
    //User
    static let uidKey = "uid"
    //user roles
    static let USER_DEFAULT = 0
    static let USER_ADMIN = 1
    static let USER_JESUS = 2
    //user notifications
    static let NOTIFICATIONS_DEFAULT = false
    //user anonymous
    static let IS_ANONYMOUS_DEFAULT = false
}