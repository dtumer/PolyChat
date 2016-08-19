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
    var usersChatRoomsService: UsersChatRoomsServiceProtocol!
    
    var course: Course!
    var user: NSDictionary!
    var chatRooms: [ChatRoom] = []
    
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
        }
        else {
            //get logged in user information
            if let user = self.authService.getUserData() {
                self.user = user
                loadChatRooms(user[Constants.uidKey] as! String)
            }
        }
    }
    
    //initializes services needed
    private func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.usersChatRoomsService = UsersChatRoomsServiceFactory.sharedInstance
    }
    
    //loads all the chat rooms that a user is in
    func loadChatRooms(userId: String) {
        //init chat rooms
        self.chatRooms = []
        self.tableView.reloadData()
        
        self.usersChatRoomsService.getChatRoomsByUser(userId, callback: { (chatRooms, error) in
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
    
    //override should perform segue
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Constants.chatRoomDetailsSegueId {
            if let cell = sender as? ChatTableViewCell {
                if let _ = cell.layer.valueForKey(Constants.ndxKey) as? Int {
                    return true
                }
            }
        }
        
        return false
    }
    
    //override of prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //segue for going to the chat details view
        if segue.identifier == Constants.chatRoomDetailsSegueId {
            let vc = segue.destinationViewController as! ChatRoomViewController
            let cell = sender as! ChatTableViewCell
            
            vc.chatRoom = self.chatRooms[cell.layer.valueForKey(Constants.ndxKey) as! Int]
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
        cell.layer.setValue(indexPath.row, forKey: Constants.ndxKey)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
}
