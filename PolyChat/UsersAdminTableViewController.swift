//
//  UsersAdminTableViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/26/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class UsersAdminTableViewController: UITableViewController {
    
    var userService: UserServiceProtocol!
    var users: [User] = []
    var selectedUser: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userService = UserServiceFactory.sharedInstance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUsers()
    }
    
    fileprivate func loadUsers() {
        userService.getAllUsers({ (users, error) in
            if let users = users {
                self.users = users
                self.tableView.reloadData()
            } else {
                print(error)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.viewUserSegueId {
            let vc = segue.destination as! ViewUserViewController
            vc.user = selectedUser
        }
    }

}

// Extension to implement tableView methods
extension UsersAdminTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersAdminReuseId, for: indexPath) as! UsersAdminTableViewCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = users[indexPath.row]
        performSegue(withIdentifier: Constants.viewUserSegueId, sender: self)
    }
    
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
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}
