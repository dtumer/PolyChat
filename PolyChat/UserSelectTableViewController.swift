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
    var groupService: GroupServiceProtocol!
    var userService: UserServiceProtocol!
    
    //current course object
    var course: Course!
    
    //objects to be created
    var chatRoom: ChatRoom?
    var group: Group?
    
    /* Creation Mode:
     * 0: Chat Room Creation
     * 1: Group Creation
     * 2: Edit ChatRoom
     * 3: Edit Group
     */
    var creationMode: Int!
    
    //the user that is creating the chat room
    var user: User!
    
    //all users encrolled in the course
    var users: [User] = []
    
    //all selected users
    var selectedUsers: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        
        //init loading screen
        ProgressHUD.shared.showOverlay(view: self.view)
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
        self.groupService = GroupServiceFactory.sharedInstance
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
                ProgressHUD.shared.hideOverlayView()
            }
        })
    }
    
    //finishes creating the chat room
    @IBAction func savePressed(_ sender: AnyObject) {
        //check if there were users selected
        if selectedUsers.count <= 1 {
            let alert = UIAlertController(title: "Error", message: "You must choose at least one other user", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if self.creationMode == Constants.createChat {
                self.chatRoomService.createChatRoom(self.course.id, users: self.selectedUsers, chatRoom: self.chatRoom!, callback: { error in
                    if let error = error {
                        //TODO log error better
                        print(error.description)
                    }
                    else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            else if self.creationMode == Constants.createGroup {
                self.groupService.createGroup(self.course.id, users: self.selectedUsers, group: self.group!, callback: { error in
                    if let error = error {
                        //TODO something about printing error
                        print(error.description)
                    }
                    else {
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            else if self.creationMode == Constants.editChat {
                //TODO edit chat members
            }
            else if self.creationMode == Constants.editGroup {
                //TODO edit group members
            }
        }
    }
}

extension UserSelectTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0 {
            TableViewHelper.removeEmptyMessage(tableView: self.tableView)
            return users.count
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Users to show", viewController: self, tableView: self.tableView)
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
