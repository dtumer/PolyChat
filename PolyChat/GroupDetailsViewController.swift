//
//  GroupDetailsViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/28/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var groupNameLabel: UITextField!
    @IBOutlet weak var editTableButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var authService: AuthServiceProtocol!
    var groupService: GroupServiceProtocol!
    
    var course: Course!     //course reference
    var group: Group!       //group reference
    var user: User!         //logged in user object
    var selectedUser: User! //selected user
    
    var users: [User] = [] //members in the group
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        initServices()
        initView()
    }
    
    //view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        } else {
            authService.getCurrentUser({ user, error in
                if let user = user {
                    self.user = user
                    self.loadUsers()
                } else if let _ = error {
                    ConnectivityAlertUtility.alert(viewController: self)
                }
            })
        }
    }
    
    //initializes services
    func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.groupService = GroupServiceFactory.sharedInstance
    }
    
    //inits the view
    func initView() {
        if self.group.name.isEmpty {
            self.groupNameLabel.text = ""
        }
        else {
            self.groupNameLabel.text = self.group.name
        }
    }
    
    func loadUsers() {
        self.users = []
        
        self.groupService.getAllUsersInAGroup(self.group.id, callback: { (users, error) in
            if let _ = error {
                ConnectivityAlertUtility.alert(viewController: self)
            }
            else {
                self.users += users!
                self.tableView.reloadData()
                ProgressHUD.shared.hideOverlayView()
            }
        })
    }
    
    //edit button pressed
    @IBAction func editMembersPressed(_ sender: Any) {
        if self.tableView.isEditing {
            self.tableView.isEditing = false
            self.editTableButton.setTitle("Edit", for: .normal)
        }
        else {
            self.tableView.isEditing = true
            self.editTableButton.setTitle("Done", for: .normal)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.text != nil && !GlobalUtilities.isBlankString(textField.text!) && textField.text != self.group.name else {
            return
        }
        
        let alert = UIAlertController(title: "Warning", message: "Are you sure you would like to change the Group name?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { sender in
            ProgressHUD.shared.showOverlay(view: self.view)
            self.group.name = textField.text!
            self.groupService.updateGroup(groupId: self.group.id, group: self.group, callback: { error in
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
    
    @IBAction func leaveGroupPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Are you sure you would like to leave \"\(self.group.name!)\"?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { sender in
            var ids = GlobalUtilities.usersToIds(users: self.users)
            ids.remove(at: ids.index(of: self.user.id)!)
            
            self.groupService.removeUserFromGroup(self.group.id, uid: self.user.id, users: ids, callback: { error in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.editMembersSegueId {
            if let vc = segue.destination as? UserSelectTableViewController {
                vc.group = self.group
                vc.course = self.course
                vc.creationMode = Constants.editGroup
                vc.usersIn = self.users
            }
        }
        else if segue.identifier == Constants.userDetailSegueId {
            if let vc = segue.destination as? UserDetailViewController {
                vc.selectedUser = self.selectedUser
                vc.course = self.course
            }
        }
    }
}

extension GroupDetailsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersReuseId, for: indexPath) as! GroupDetailsTableViewCell
            cell.user = users[indexPath.row]
            
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
                leaveGroupPressed(self)
            }
            else {
                self.users.remove(at: indexPath.row)
                
                self.groupService.removeUserFromGroup(self.group.id, uid: user.id, users: GlobalUtilities.usersToIds(users: self.users), callback: { error in
                    if let _ = error {
                        ConnectivityAlertUtility.alert(viewController: self)
                    }
                    else {
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.users.count {
            self.selectedUser = self.users[indexPath.row]
            
            performSegue(withIdentifier: Constants.userDetailSegueId, sender: self)
        }
    }
}
