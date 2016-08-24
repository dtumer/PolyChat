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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.chatRooms = []
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        } else {
            // get currently logged in user
            authService.getCurrentUser({ user, error in
                if let user = user {
                    self.user = user
                    self.loadChatRooms(user.id)
                } else if let error = error {
                    print(error)
                }
            })
        }
    }
    
    //initializes services needed
    private func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.chatRoomService = ChatRoomServiceFactory.sharedInstance
    }
    
    //loads all the chat rooms that a user is in
    func loadChatRooms(userId: String) {
        //init chat rooms
        self.chatRooms = []
        self.tableView.reloadData()
        
        self.chatRoomService.getChatRoomsInCourseWithUser(self.course.id, userId: user.id, callback: { (chatRooms, error) in
            if let chatRooms = chatRooms {
                self.chatRooms += chatRooms
                self.tableView.reloadData()
            }
            else {
                //TODO change this to log instead of print
                print(error?.description)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.chatRoomDetailsSegueId {
            let vc = segue.destinationViewController as! ChatRoomViewController
            vc.chatRoom = selectedChatRoom
            vc.senderId = user.id as String
            vc.senderDisplayName = user.name
        }
    }
}

extension ChatTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.chatCellReuseId, forIndexPath: indexPath) as! ChatTableViewCell
        cell.chatRoom = self.chatRooms[indexPath.row]
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedChatRoom = chatRooms[indexPath.row]
        performSegueWithIdentifier(Constants.chatRoomDetailsSegueId, sender: self)
    }
}
