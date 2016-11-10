//
//  ViewUserViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ViewUserViewController: UIViewController {
    
    var courseService: CourseServiceProtocol!
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUserLabels()
        loadUserCourses()
    }
    
    fileprivate func initServices() {
        self.courseService = CourseServiceFactory.sharedInstance
    }
    
    fileprivate func loadUserCourses() {
        courseService.getCoursesUserIsEnrolledIn(user.id, callback: { courses, error in
            if let courses = courses {
                self.userCourses = courses
                self.userCoursesTableView.reloadData()
            }
            else {
                //TODO change this to a logger
                print(error)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.editUserSegueId {
            let vc = segue.destination as! EditUserViewController
            vc.user = self.user
            vc.userCourses = self.userCourses
        }
    }
    
    fileprivate func setUserLabels() {
        emailLabel.text = user.email
        nameLabel.text = user.name
        roleLabel.text = String(user.role)
        notificationsLabel.text = user.notifications.description
        anonymousLabel.text = user.is_anonymous.description
    }
    
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.editUserSegueId, sender: self)
    }
    

}

// User's courses table view delegate/datasource
extension ViewUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userCourseAdminReuseId) as! CoursesAdminTableViewCell
        cell.course = userCourses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.userCoursesAdminSectionHeader
    }
    
}
