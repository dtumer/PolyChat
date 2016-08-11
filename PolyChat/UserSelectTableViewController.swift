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
    var usersChatRoomsService: UsersChatRoomsServiceProtocol!
    var coursesUsersService: CoursesUsersServiceProtocol!
    
    var course: Course!
    var chatRoom: ChatRoom!
    var users: [User] = []
    var selectedUsers: [User] = []

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
        self.usersChatRoomsService = UsersChatRoomsServiceFactory.getUsersChatRoomsService(Constants.CURRENT_SERVICE_KEY)
        self.coursesUsersService = CoursesUsersServiceFactory.getCoursesUsersService(Constants.CURRENT_SERVICE_KEY)
    }
    
    //loads all users in a course
    private func loadUsers() {
        self.coursesUsersService.getEnrolledUsers(self.course.id, callback: { (users, error) in
            if let error = error {
                //TODO log error better
                print(error.description)
            }
            else {
                self.users += users!
                self.tableView.reloadData()
            }
        })
    }
    
    //finishes creating the chat room
    @IBAction func createChatRoomPressed(sender: AnyObject) {
        self.usersChatRoomsService.createChatRoom(self.course.id, users: self.selectedUsers, chatRoom: self.chatRoom, callback: { error in
            if let error = error {
                //TODO log error better
                print(error.description)
            }
            else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.usersReuseId, forIndexPath: indexPath) as! UsersSelectTableViewCell
        
        cell.user = users[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! UsersSelectTableViewCell
        
        //if it's selected
        if cell.accessoryType == .Checkmark {
            cell.accessoryType = .None
            let ndx = selectedUsers.indexOf({$0.id == cell.user.id})
            selectedUsers.removeAtIndex(ndx!)
        }
        //if we're adding for first time
        else {
            cell.accessoryType = .Checkmark
            selectedUsers.append(users[indexPath.row])
        }
    }
}
