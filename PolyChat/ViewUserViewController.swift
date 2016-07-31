//
//  ViewUserViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ViewUserViewController: UIViewController {
    
    var usersCoursesService: UsersCoursesServiceProtocol!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var anonymousLabel: UILabel!
    @IBOutlet weak var userCoursesTableView: UITableView!
    
    var user: User!
    var userCourses: [Course] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        setUserLabels()
        loadUserCourses()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setUserLabels()
        loadUserCourses()
    }
    
    private func initServices() {
        self.usersCoursesService = UsersCoursesServiceFactory.getUsersCoursesService(Constants.CURRENT_SERVICE_KEY)
    }
    
    private func loadUserCourses() {
        usersCoursesService.getEnrolledCourses(user.id, callback: { courses, error in
            if let courses = courses {
                self.userCourses = courses
                self.userCoursesTableView.reloadData()
            } else {
                print(error)
            }
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.editUserSegueId {
            let vc = segue.destinationViewController as! EditUserViewController
            vc.user = self.user
            vc.userCourses = self.userCourses
        }
    }
    
    private func setUserLabels() {
        emailLabel.text = user.email
        nameLabel.text = user.name
        roleLabel.text = String(user.role)
        notificationsLabel.text = user.notifications.description
        anonymousLabel.text = user.is_anonymous.description
    }
    
    @IBAction func editPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier(Constants.editUserSegueId, sender: self)
    }
    

}

// User's courses table view delegate/datasource
extension ViewUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCourses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.userCourseAdminReuseId) as! CoursesAdminTableViewCell
        cell.course = userCourses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.userCoursesAdminSectionHeader
    }
    
}