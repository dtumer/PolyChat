//
//  GroupTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    //services
    var authService: AuthServiceProtocol!
    var groupService: GroupServiceProtocol!
    
    //course object
    var course: Course!
    
    //logged in user object
    var user: User!
    
    //groups in the specified course
    var groups: [Group] = []
    
    var selectedGroup: Group!   //selected group
    
    //logged in flag
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
                    self.loadGroups(user.id, isRefresh: false)
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
    
    //initializes the services
    func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.groupService = GroupServiceFactory.sharedInstance
    }
    
    //loads all the groups that a user is in
    func loadGroups(_ userId: String, isRefresh: Bool) {
        self.groupService.getGroupsInCourseWithUser(self.course.id, userId: userId, callback: { (groups, error) in
            if let groups = groups {
                self.groups = groups
            }
            else {
                if error?.code != 1 {
                    ConnectivityAlertUtility.alert(viewController: self)
                }
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
    
    //refresh function
    func refresh() {
        loadGroups(self.user.id, isRefresh: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.groupDetailSegueId {
            let vc = segue.destination as! GroupDetailsViewController
            vc.group = selectedGroup
            vc.course = self.course
        }
    }
}

/* TABLE VIEW EXTENSION */
extension GroupTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if groups.count > 0 {
            TableViewHelper.removeEmptyMessage(tableView: self.tableView)
            return groups.count
        }
        else {
            TableViewHelper.EmptyMessage(message: "There are no Groups to show", viewController: self, tableView: self.tableView)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.groupCellReuseId, for: indexPath) as! GroupTableViewCell
        cell.group = self.groups[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGroup = groups[indexPath.row]
        performSegue(withIdentifier: Constants.groupDetailSegueId, sender: self)
    }
}
