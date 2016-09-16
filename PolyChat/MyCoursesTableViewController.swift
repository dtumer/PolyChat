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
    
    //logged in user
    var user: User!
    
    //list of courses that the logged in user is enrolled in
    var courses: [Course] = []
    
    //on view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        initMenu()
        
        //makes sure there's no weird grayness happening in the nav bar
        self.navigationController?.navigationBar.translucent = false
    }
    
    //initializes all services needed by this controller
    private func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.usersCoursesService = UsersCoursesServiceFactory.sharedInstance
        self.courseService = CourseServiceFactory.sharedInstance
    }
    
    //initializes the slide out menu
    private func initMenu() {
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    //on view did appear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //init courses
        self.courses = []
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        }
        else {
            //get logged in user information
            self.authService.getCurrentUser({ (user, error) in
                if let error = error {
                    //TODO log error
                    print(error.description)
                }
                else {
                    self.user = user!
                    self.loadCourses(self.user.id)
                }
            })
        }
    }
    
    //loads the courses from the database
    func loadCourses(uid: String) {
        self.courseService.getCoursesUserIsEnrolledIn(uid, callback: { (courses, error) in
            if let courses = courses {
                self.courses = courses
                self.tableView.reloadData()
            }
            else {
                //TODO change this to log errors instead of printing them
                print(error?.description)
            }
        })
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

//table view extension
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