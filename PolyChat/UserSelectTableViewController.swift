//
//  UserSelectTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class UserSelectTableViewController: UITableViewController {
    
    //services
    var authService: AuthServiceProtocol!
    var chatRoomService: ChatRoomServiceProtocol!
    var usersCoursesService: UsersCoursesServiceProtocol!
    
    var course: Course!
    var chatRoom: ChatRoom!
    var users: [User]! = []
    var selectedUsers: [User]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.users = []
        self.selectedUsers = []
        
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        }
        else {
            loadUsers()
        }
    }
    
    //initializes services that we will need
    private func initServices() {
        self.authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        self.chatRoomService = ChatRoomServiceFactory.getChatRoomService(Constants.CURRENT_SERVICE_KEY)
        self.usersCoursesService = UsersCoursesServiceFactory.getUsersCoursesService(Constants.CURRENT_SERVICE_KEY)
    }
    
    //loads all users in a course
    private func loadUsers() {
        
    }
    
    //finishes creating the chat room
    @IBAction func createChatRoomPressed(sender: AnyObject) {
    }
}

extension UserSelectTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        return cell
    }
}
