//
//  ChatDetailsViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/21/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ChatDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //reference to the tableView
    @IBOutlet weak var tableView: UITableView!
    
    //services
    var authService: AuthServiceProtocol!
    var chatRoomService: ChatRoomServiceProtocol!
    
    //holds references to available objects
    var user: User!             //logged in user
    var course: Course!         //current course
    var chatRoom: ChatRoom!     //current chat room
    
    var users: [User] = []      //all users in Chat Room
    
    //view Did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        initNavigation()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(ChatDetailsViewController.editMembers))
    }
    
    //loads the users in the chat room
    func loadUsers() {
        //TODO finish this
    }
    
    func editMembers() {
        performSegue(withIdentifier: Constants.editMembersSegueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.editMembersSegueId {
            if let vc = segue.destination as? UserSelectTableViewController {
                vc.chatRoom = self.chatRoom
                vc.course = self.course
                vc.creationMode = Constants.editChat
            }
        }
    }
}

/* TABLE VIEW EXTENSION */
extension ChatDetailsViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0 {
            TableViewHelper.removeEmptyMessage(tableView: self.tableView)
            return users.count
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Users to show", viewController: self, tableView: self.tableView)
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersReuseId, for: indexPath) as! ChatRoomDetailsTableViewCell
        
        cell.user = self.users[indexPath.row]
        
        return cell
    }
}
