//
//  ChatDetailsViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/21/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ChatDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    //reference to the tableView
    @IBOutlet weak var tableView: UITableView!
    
    //reference to text field
    @IBOutlet weak var chatRoomNameTextField: UITextField!
    
    //reference to edit button
    @IBOutlet weak var membersTableEditButton: UIButton!
    
    //services
    var authService: AuthServiceProtocol!
    var chatRoomService: ChatRoomServiceProtocol!
    
    //holds references to available objects
    var user: User!             //logged in user
    var course: Course!         //current course
    var chatRoom: ChatRoom!     //current chat room
    
    var users: [User] = []      //all users in Chat Room
    
    var selectedUser: User!
    
    //view Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        initNavigation()
        initView()
        
        //start progress hud
        ProgressHUD.shared.showOverlay(view: self.view)
    }
    
    //view did appear
    override func viewDidAppear(_ animated: Bool) {
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        } else {
            authService.getCurrentUser({ user, error in
                if let user = user {
                    self.user = user
                    self.loadUsers()
                } else if let error = error {
                    //TODO alert out something and log error
                    print(error)
                }
            })
        }
    }
    
    //initializes services
    func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.chatRoomService = ChatRoomServiceFactory.sharedInstance
    }
    
    //initializes the nav bar
    func initNavigation() {
        self.navigationItem.title = "Details"
    }
    
    //inits view elements
    func initView() {
        if self.chatRoom.name.isEmpty {
            self.chatRoomNameTextField.text = ""
        }
        else {
            self.chatRoomNameTextField.text = self.chatRoom.name
        }
    }
    
    //Delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text != nil && !GlobalUtilities.isBlankString(textField.text!) && textField.text != self.chatRoom.name else {
            return
        }
        
        let alert = UIAlertController(title: "Warning", message: "Are you sure you would like to change the Chat Room name?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { sender in
            ProgressHUD.shared.showOverlay(view: self.view)
            self.chatRoom.name = textField.text!
            self.chatRoomService.updateChatRoom(chatRoomId: self.chatRoom.id, chatRoom: self.chatRoom, callback: { error in
                ProgressHUD.shared.hideOverlayView()
                
                if let error = error {
                    // TODO: Handle this error
                    print(error)
                }
                else {
                    ConnectivityAlertUtility.alert(viewController: self, title: "Congratulations!", message: "The Chat Room name has been updated")
                }
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //loads the users in the chat room
    func loadUsers() {
        self.users = []
        
        self.chatRoomService.getAllUsersInAChatRoom(self.chatRoom.id, callback: { (users, error) in
            if let error = error {
                ConnectivityAlertUtility.alert(viewController: self)
            }
            else {
                self.users += users!
                self.tableView.reloadData()
                ProgressHUD.shared.hideOverlayView()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.editMembersSegueId {
            if let vc = segue.destination as? UserSelectTableViewController {
                vc.chatRoom = self.chatRoom
                vc.course = self.course
                vc.creationMode = Constants.editChat
                vc.usersIn = self.users
            }
        }
        else if segue.identifier == Constants.userDetailSegueId {
            if let vc = segue.destination as? UserDetailViewController {
                vc.selectedUser = self.selectedUser
            }
        }
    }
    
    @IBAction func editMembers(_ sender: Any) {
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.membersTableEditButton.setTitle("Edit", for: .normal)
        }
        else {
            self.tableView.isEditing = true
            self.membersTableEditButton.setTitle("Done", for: .normal)
        }
        //performSegue(withIdentifier: Constants.editMembersSegueId, sender: self)
    }
    
    @IBAction func leaveChatRoomPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you would like to leave \"\(self.chatRoom.name)\"?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { sender in
            var ids = GlobalUtilities.usersToIds(users: self.users)
            ids.remove(at: ids.index(of: self.user.id)!)
            
            self.chatRoomService.removeUserFromChatRoom(self.chatRoom.id, uid: self.user.id, users: ids, callback: { error in
                if let _ = error {
                    ConnectivityAlertUtility.alert(viewController: self)
                }
                else {
                    _ = self.navigationController?.popToRootViewController(animated: true)
                }
            })
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

/* TABLE VIEW EXTENSION */
extension ChatDetailsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0 {
            TableViewHelper.removeEmptyMessage(tableView: self.tableView)
            return users.count + 1
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Users to show", viewController: self, tableView: self.tableView)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.users.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.addUserReuseId, for: indexPath)
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersReuseId, for: indexPath) as! ChatRoomDetailsTableViewCell
            
            cell.user = self.users[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == self.users.count {
            return .none
        }
        else {
            return .delete
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = self.users[indexPath.row]
            
            if user.id == self.user.id {
                leaveChatRoomPressed(self)
            }
            else {
                self.users.remove(at: indexPath.row)
                
                self.chatRoomService.removeUserFromChatRoom(self.chatRoom.id, uid: user.id, users: GlobalUtilities.usersToIds(users: self.users), callback: { error in
                    if let error = error {
                        //TODO catch error
                        print(error)
                    }
                    else {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.users[indexPath.row]
        
        performSegue(withIdentifier: Constants.userDetailSegueId, sender: self)
    }
}
