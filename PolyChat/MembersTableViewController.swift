//
//  MembersTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 8/17/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class MembersTableViewController: UITableViewController {

    //service variables
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    
    //all users in the course
    var users: [User] = []
    
    //user that is logged in
    var user: User!
    
    //course object
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
    }
    
    //initializes service that will be needed by this controller
    private func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.userService = UserServiceFactory.sharedInstance
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.users = []
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        } else {
            // get currently logged in user
            authService.getCurrentUser({ user, error in
                if let user = user {
                    self.user = user
                    self.loadUsers(self.course.id)
                } else if let error = error {
                    print(error)
                }
            })
        }
    }
    
    //loads all the users in this course
    func loadUsers(courseId: String) {
        //init users object
        self.users = []
        
        userService.getAllUsersInACourse(courseId, userId: "", callback: { (users, error) in
            if let users = users {
                self.users += users
                self.tableView.reloadData()
            }
            else {
                //TODO change this to log instead of print
                print(error?.description)
            }
        })

    }
}

//table view extension
extension MembersTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.usersReuseId, forIndexPath: indexPath) as! MembersTableViewCell

        cell.user = users[indexPath.row]

        return cell
    }
}
