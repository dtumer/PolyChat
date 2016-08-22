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
    
    //current course object
    var course: Course!
    
    //chat room object of the chat room being created
    var chatRoom: ChatRoom!
    
    //the user that is creating the chat room
    var user: User!
    
    //all users encrolled in the course
    var users: [User] = []
    
    //all selected users
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
            self.authService.getCurrentUser({ (user, error) in
                if let error = error {
                    //TODO change this print statement
                    print(error.description)
                }
                else {
                    self.user = user!
                    self.selectedUsers.append(self.user)
                    self.loadUsers(self.course.id)
                }
            })
        }
    }
    
    //initializes services that we will need
    private func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.usersChatRoomsService = UsersChatRoomsServiceFactory.sharedInstance
        self.coursesUsersService = CoursesUsersServiceFactory.sharedInstance
    }
    
    //loads all users in a course
    private func loadUsers(courseId: String) {
        self.coursesUsersService.getEnrolledUsers(self.user.id, courseId: courseId, callback: { (users, error) in
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
