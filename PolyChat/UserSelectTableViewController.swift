//
//  UserSelectTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit
import OneSignal

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
     * 2: Edit ChatRoom (adding users)
     * 3: Edit Group (adding users)
     */
    var creationMode: Int!
    
    //the user that is creating the chat room
    var user: User!
    
    //all users enrolled in the course
    var users: [User] = []
    
    //reference to all the users already in the chat or group
    var usersIn: [User]?
    
    //all selected users
    var selectedUsers: [User] = []
    
    // keep track if notification has been sent
    var notificationSent = false

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
                    
                    //if we're creating something add the user in
                    if self.creationMode == Constants.createChat || self.creationMode == Constants.createGroup {
                        self.selectedUsers.append(self.user)
                    }
                    
                    self.loadUsers(self.course.id, isRefresh: false)
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
    fileprivate func loadUsers(_ courseId: String, isRefresh: Bool) {
        if self.creationMode == Constants.createChat || self.creationMode == Constants.createGroup {
            self.userService.getAllUsersInACourse(courseId, userId: self.user.id, callback: { (users, error) in
                if let _ = error {
                    ConnectivityAlertUtility.alert(viewController: self)
                }
                else {
                    self.users += users!
                    self.tableView.reloadData()
                }
                
                if isRefresh {
                    //Do refresh end
                }
                else {
                    ProgressHUD.shared.hideOverlayView()
                }
            })
        }
        else if self.creationMode == Constants.editChat || self.creationMode == Constants.editGroup {
            self.userService.getAllUsersInACourseNotInUsers(courseId: courseId, users: GlobalUtilities.usersToIds(users: self.usersIn!), callback: { (users, error) in
                if let _ = error {
                    ConnectivityAlertUtility.alert(viewController: self)
                }
                else {
                    self.users += users!
                }
                
                self.tableView.reloadData()
                
                if isRefresh {
                    //Do refresh end
                }
                else {
                    ProgressHUD.shared.hideOverlayView()
                }
            })
        }
    }
    
    /* Notify users that they have been added to something */
    fileprivate func notifyUsers(_ users: [User], course: Course!, chatRoom: ChatRoom?, group: Group?) {
        var notifyIds = [String]()
        for user in users {
            if (user.notifications && !user.notifyId.isEmpty) { //add this when done dev testing: && self.user.notifyId != user.notifyId) {
                notifyIds.append(user.notifyId)
            }
        }
        if !notificationSent {
            var message: String = "You have been added to \(course.name!) "
            if let chatRoom = chatRoom {
                message += "chatroom: \(chatRoom.name!)"
            } else if let group = group {
                message += "group: \(group.name!)"
            }
            OneSignal.postNotification([
                "contents": ["en": message],
                //"headings": ["en": "*Title*"],
                //"subtitle": ["en": "*Subtitle*"],
                "include_player_ids": notifyIds
                ], onSuccess: { result in
                    print("Successfully sent Notification")
                    print(result ?? "Result")
                    
            }, onFailure: { error in
                print("Error on sending Notification")
                print(error ?? "Error")
            })
            self.notificationSent = true
        }
    }
    
    //finishes creating the chat room
    @IBAction func savePressed(_ sender: AnyObject) {
        var isError = false
        ProgressHUD.shared.showOverlay(view: self.view)
        
        //set errors
        if self.creationMode == Constants.createChat && selectedUsers.count <= 1 {
            isError = true
        }
        else if self.creationMode == Constants.editChat && selectedUsers.count < 1 {
            isError = true
        }
        
        //check if there were users selected
        if isError {
            let alert = UIAlertController(title: "Error", message: "You must choose at least one other user", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if self.creationMode == Constants.createChat {
                self.chatRoomService.createChatRoom(self.course.id, users: self.selectedUsers, chatRoom: self.chatRoom!, callback: { (chatRoom, error) in
                    if let error = error {
                        //TODO log error better
                        print(error.description)
                    }
                    else if let chatRoom = chatRoom {
                        self.notifyUsers(self.selectedUsers, course: self.course, chatRoom: chatRoom, group: nil)
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
                        self.notifyUsers(self.selectedUsers, course: self.course, chatRoom: nil, group: self.group!)
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
            else if self.creationMode == Constants.editChat {
                self.chatRoomService.addUsersToChatRoom(chatRoomId: self.chatRoom!.id, users: self.selectedUsers, callback: { error in
                    if let _ = error {
                        ConnectivityAlertUtility.alert(viewController: self)
                    }
                    else {
                        self.notifyUsers(self.selectedUsers, course: self.course, chatRoom: self.chatRoom!, group: nil)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    
                    ProgressHUD.shared.hideOverlayView()
                })
            }
            else if self.creationMode == Constants.editGroup {
                self.groupService.addUsersToGroup(groupId: self.group!.id, users: self.selectedUsers, callback: { error in
                    if let _ = error {
                        ConnectivityAlertUtility.alert(viewController: self)
                    }
                    else {
                        self.notifyUsers(self.selectedUsers, course: self.course!, chatRoom: nil, group: self.group!)
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    
                    ProgressHUD.shared.hideOverlayView()
                })
            }
        }
    }
    
    func refresh() {
        self.loadUsers(self.course.id, isRefresh: true)
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
        
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            
            let ndx = selectedUsers.index(where: {$0.id == cell.user.id})
            selectedUsers.remove(at: ndx!)
        }
        else {
            cell.accessoryType = .checkmark
            
            selectedUsers.append(users[indexPath.row])
        }
    }
}
