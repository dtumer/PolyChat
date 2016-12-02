//
//  ChatTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ChatTableViewController: UITableViewController {

    //services
    var authService: AuthServiceProtocol!
    var chatRoomService: ChatRoomServiceProtocol!
    
    //course object
    var course: Course!
    
    //logged in user object
    var user: User!
    
    //all chat rooms in this course that the logged in user is in
    var chatRooms: [ChatRoom] = []
    
    //the chat room that is selected
    var selectedChatRoom: ChatRoom!
    
    //flag for determining whether or not the user is authenticated
    var loggedInFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        
        //init loading screen
        ProgressHUD.shared.showOverlay(view: self.view)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            loggedInFlag = false
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        } else {
            // get currently logged in user
            loggedInFlag = true
            
            authService.getCurrentUser({ user, error in
                if let user = user {
                    self.user = user
                    self.loadChatRooms(user.id, isRefresh: false)
                } else if let error = error {
                    //TODO alert out something and log error
                    print(error)
                }
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if a user is logged in
        if !loggedInFlag {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        }
    }
    
    //initializes services needed
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.chatRoomService = ChatRoomServiceFactory.sharedInstance
    }
    
    //refreshes the view
    func refresh() {
        loadChatRooms(self.user.id, isRefresh: true)
    }
    
    //loads all the chat rooms that a user is in
    func loadChatRooms(_ userId: String, isRefresh: Bool) {
        //init chat rooms
        self.chatRooms = []
        
        self.chatRoomService.getChatRoomsInCourseWithUser(self.course.id, userId: user.id, callback: { (chatRooms, error) in
            if let chatRooms = chatRooms {
                self.chatRooms += chatRooms
            }
            else {
                ConnectivityAlertUtility.alert(viewController: self)
            }
            
            self.tableView.reloadData()
            
            if isRefresh {
                self.refreshControl?.endRefreshing()
            }
            else {
                self.refreshControl = UIRefreshControl()
                self.refreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
                self.tableView.addSubview(self.refreshControl!)
                
                ProgressHUD.shared.hideOverlayView()
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.chatRoomDetailsSegueId {
            let vc = segue.destination as! ChatRoomViewController
            vc.chatRoom = selectedChatRoom
            vc.course = self.course
            vc.senderId = user.id as String
            vc.senderDisplayName = user.name
        }
    }
}

extension ChatTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if chatRooms.count > 0 {
            TableViewHelper.removeEmptyMessage(tableView: self.tableView)
            return chatRooms.count
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Chats to show", viewController: self, tableView: self.tableView)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.chatCellReuseId, for: indexPath) as! ChatTableViewCell
        cell.chatRoom = self.chatRooms[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChatRoom = chatRooms[indexPath.row]
        performSegue(withIdentifier: Constants.chatRoomDetailsSegueId, sender: self)
    }
}
