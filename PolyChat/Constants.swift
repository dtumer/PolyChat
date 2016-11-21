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
    /* App Constants */
    //keychain constants
    static let APP_CERT = "FE313B23BE54C7843CFB944788B01EBF"
    static let APP_CERT_KEY = "app_cert"
    
    //service keys for which server/database services to use in-app
    static let CURRENT_SERVICE_KEY: String = Constants.FIREBASE_SERVICE_KEY
    static let FIREBASE_SERVICE_KEY: String = "firebase"
    static let MOCK_SERVICE_KEY: String = "mock"
    //static let MYSQL_SERVICE_KEY: String = "mysql"
    
    //hash key for setting ndx on a cell
    static let ndxKey = "ndx"
    
    //database keys
    static let idKey = "id"
    
    //table keys
    static let usersDBKey = "USERS" //specifies objects in db that contain USER data
    static let chatRoomsDBKey = "CHATROOMS" //specifies objects in db that contain CHAT_ROOM data
    static let messagesDBKey = "MESSAGES" //specifies objects in db that contain MESSAGE data
    static let coursesDBKey = "COURSES" // specifies objects in db that contain COURSE data
    static let groupsDBKey = "GROUPS" // specifies object in bd that contain GROUP data
    static let usersGroupsDBKey = "USERS_GROUPS"
    static let groupsUsersDBKey = "GROUPS_USERS"
    static let usersCoursesDBKey = "USERS_COURSES"
    static let coursesUsersDBKey = "COURSES_USERS"
    static let usersChatRoomsDBKey = "USERS_CHATROOMS"
    static let chatRoomsUsersDBKey = "CHATROOMS_USERS"
    static let chatRoomsMessagesDBKey = "CHATROOMS_MESSAGES"
    static let coursesChatRoomsDBKey = "COURSES_CHATROOMS"
    static let coursesGroupsDBKey = "COURSES_GROUPS"
    
    //TableViewController Reuse Identifiers
    static let myCoursesReuseId = "MyCourseCell"
    static let usersReuseId = "UserCell"
    static let coursesReuseId = "CourseCell"
    static let usersAdminReuseId = "UsersAdminCell"
    static let menuReuseId = "MenuCell"
    static let userCourseAdminReuseId = "UserCourseAdminCell"
    static let userCourseAdminEditReuseId = "UserCourseAdminEditCell"
    static let userCourseAdminAddReuseId = "UserCourseAdminAddCell"
    static let chatCellReuseId = "ChatCell"
    static let groupCellReuseId = "GroupCell"
    
    //Segue Identifiers
    static let loginSegueId = "LoginSegue"
    static let viewUserSegueId = "ViewUserSegue"
    static let editUserSegueId = "EditUserSegue"
    static let createChatSegueId = "CreateChatSegue"
    static let createGroupSegueId = "CreateGroupSegue"
    static let createChatNextSegueId = "CreateChatNextSegue"
    static let createGroupNextSegueId = "CreateGroupNextSegue"
    static let chatRoomDetailsSegueId = "ChatRoomDetailsSegue"
    
    //Users addition mode
    static let createChat = 0
    static let createGroup = 1
    
    /* Model Constants */
    //User
    static let uidKey = "uid"
    static let emailKey = "email"
    //user roles
    static let USER_DEFAULT = 0
    static let USER_ADMIN = 1
    static let USER_JESUS = 2
    //user notifications
    static let NOTIFICATIONS_DEFAULT = false
    //user anonymous
    static let IS_ANONYMOUS_DEFAULT = false
    
    // Section headers
    static let userCoursesAdminSectionHeader = "Courses"
}
