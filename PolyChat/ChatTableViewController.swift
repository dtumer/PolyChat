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
    
    var course: Course!
    var user: NSDictionary!
    var chatRooms: [ChatRoom]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.chatRooms = []
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            //TODO GET RID OF PRINT
            print("NO OPEN SESSION")
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
        self.authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
    }
    
    func loadChatRooms(userId: String) {
        
    }
}

extension ChatTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
