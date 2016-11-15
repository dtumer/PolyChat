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
        
        //init loading screen
        ProgressHUD.shared.showOverlay(view: self.view)
        
        //sets up refresh control
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    //initializes service that will be needed by this controller
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.userService = UserServiceFactory.sharedInstance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.users = []
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
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
    func loadUsers(_ courseId: String) {        
        userService.getAllUsersInACourse(courseId, userId: "", callback: { (users, error) in
            if let users = users {
                self.users = users
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                ProgressHUD.shared.hideOverlayView()
            }
            else {
                //TODO change this to log instead of print
            }
        })
    }
    
    //function for refreshing
    func refresh() {
        loadUsers(self.course.id)
    }
}

//table view extension
extension MembersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0 {
            TableViewHelper.removeEmptyMessage(viewController: self)
            return self.users.count
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Users to show", viewController: self)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersReuseId, for: indexPath) as! MembersTableViewCell

        cell.user = users[indexPath.row]

        return cell
    }
}
