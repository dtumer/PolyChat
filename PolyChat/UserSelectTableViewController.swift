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
    var userService: UserServiceProtocol!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        self.users = []
        self.selectedUsers = []
        
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
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
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.chatRoomService = ChatRoomServiceFactory.sharedInstance
        self.userService = UserServiceFactory.sharedInstance
    }
    
    //loads all users in a course
    fileprivate func loadUsers(_ courseId: String) {
        self.userService.getAllUsersInACourse(courseId, userId: self.user.id, callback: { (users, error) in
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
    @IBAction func createChatRoomPressed(_ sender: AnyObject) {
        //check if there were users selected
        if selectedUsers.count <= 1 {
            let alert = UIAlertController(title: "Error", message: "Please choose at least one other user to chat with!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            self.chatRoomService.createChatRoom(self.course.id, users: self.selectedUsers, chatRoom: self.chatRoom, callback: { error in
                if let error = error {
                    //TODO log error better
                    print(error.description)
                }
                else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}

extension UserSelectTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0 {
            TableViewHelper.removeEmptyMessage(viewController: self)
            return users.count
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Users to show", viewController: self)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersReuseId, for: indexPath) as! UsersSelectTableViewCell
        
        cell.user = users[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UsersSelectTableViewCell
        
        //if it's selected
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            let ndx = selectedUsers.index(where: {$0.id == cell.user.id})
            selectedUsers.remove(at: ndx!)
        }
        //if we're adding for first time
        else {
            cell.accessoryType = .checkmark
            selectedUsers.append(users[indexPath.row])
        }
    }
}
