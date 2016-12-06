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
    var selectedUser: User!
    
    //course object
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        
        //init loading screen
        ProgressHUD.shared.showOverlay(view: self.view)
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
                    self.loadUsers(self.course.id, isRefresh: false)
                } else if let error = error {
                    print(error)
                }
            })
        }
    }
    
    //loads all the users in this course
    func loadUsers(_ courseId: String, isRefresh: Bool) {
        self.users = []
        
        userService.getAllUsersInACourse(courseId, userId: self.user.id, callback: { (users, error) in
            if let users = users {
                self.users = users
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
    
    //function for refreshing
    func refresh() {
        loadUsers(self.course.id, isRefresh: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.userDetailSegueId {
            if let vc = segue.destination as? UserDetailViewController {
                vc.selectedUser = self.selectedUser
                vc.course = self.course
            }
        }
    }
}

//table view extension
extension MembersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users.count > 0 {
            TableViewHelper.removeEmptyMessage(tableView: self.tableView)
            return self.users.count
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Users to show", viewController: self, tableView: self.tableView)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersReuseId, for: indexPath) as! MembersTableViewCell

        cell.user = users[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.users[indexPath.row]
        
        performSegue(withIdentifier: Constants.userDetailSegueId, sender: self)
    }
}
