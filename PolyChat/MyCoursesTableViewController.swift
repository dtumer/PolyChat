//
//  MyCoursesTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class MyCoursesTableViewController: UITableViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    //services variables
    var authService: AuthServiceProtocol!
    var usersCoursesService: UsersCoursesServiceProtocol!
    var courseService: CourseServiceProtocol!
    
    //instance variables for UI
    var user: NSDictionary!
    var courses: [Course] = []
    
    //on view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initMockData()
        
        //retrieve services we will need
        self.authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        self.usersCoursesService = UsersCoursesServiceFactory.getUsersCoursesService(Constants.CURRENT_SERVICE_KEY)
        self.courseService = CourseServiceFactory.getCourseService(Constants.CURRENT_SERVICE_KEY)
    }
    
    //on view did appear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            print("NO OPEN SESSION")
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        }
        else {
            //get logged in user information
            if let user = self.authService.getUserData() {
                self.user = user
                //loadCourses(user[Constants.uidKey] as! String)
            }
        }
    }
    
    private func performAuthentication(completion: () -> ()) {
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
            return
        }
        
        if let user = self.authService.getUserData() {
            self.user = user
            loadCourses(user[Constants.uidKey] as! String)
            completion()
        }
    }
    
    //loads the courses from the database
    func loadCourses(uid: String) {
        self.usersCoursesService.getEnrolledCourses(uid, callback: { (courses, error) in
            if let courses = courses {
                print("here")
                self.courses = courses
            }
        })
//        self.myCoursesService.getEnrolledCourses(uid, callback: { (courses, error) in
//            if let courses = courses {
//                self.courses = courses
//                self.tableView.reloadData()
//            }
//            else {
//                print("ERROR: \(error?.localizedDescription)")
//            }
//        })
    }
    
    //used to initialize mock data in database
    private func initMockData() {
        //let mockInit = FirebaseInitMockDatabase()
    
        //mockInit.initMockDB()
    }
    
    @IBAction func signOutPressed(sender: AnyObject) {
        if self.authService.logout() {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
        
        //print error?
    }
}

extension MyCoursesTableViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.myCoursesReuseId, forIndexPath: indexPath) as! MyCoursesTableViewCell
        
        cell.course = courses[indexPath.row]

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CourseDetailSegue" {
            if let cell = sender as? MyCoursesTableViewCell {
                let toVC = segue.destinationViewController as! CourseViewController
                toVC.course = cell.course
            }
        }
    }
}