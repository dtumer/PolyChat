//
//  MyCoursesTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class MyCoursesTableViewController: UITableViewController, SWRevealViewControllerDelegate {
    
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
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
        
        //makes sure there's no weird grayness happening in the nav bar
        self.navigationController?.navigationBar.isTranslucent = false
        
        //set auto layout view insets
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    //initializes all services needed by this controller
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.usersCoursesService = UsersCoursesServiceFactory.sharedInstance
        self.courseService = CourseServiceFactory.sharedInstance
    }
    
    //initializes the slide out menu
    fileprivate func initMenu() {
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let menuVC = self.revealViewController().rearViewController as! MainMenuTableViewController
            menuVC.user = self.user
            self.revealViewController().delegate = self
        }
    }
    
    //on view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //init courses
        self.courses = []
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
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
                    // Menu needs user information since it varies based on user (username, role, etc.)
                    self.initMenu()
                }
            })
        }
    }
    
    //loads the courses from the database
    func loadCourses(_ uid: String) {
        self.courseService.getCoursesUserIsEnrolledIn(uid, callback: { (courses, error) in
            if let courses = courses {
                self.courses = courses
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
            else {
                //TODO change this to log errors instead of printing them
            }
        })
    }
    
    //refresh handler
    func refresh() {
        loadCourses(self.user.id)
    }
    
    //used to initialize mock data in database
    fileprivate func initMockData() {
        //let mockInit = FirebaseInitMockDatabase()
    
        //mockInit.initMockDB()
    }
    
    @IBAction func signOutPressed(_ sender: AnyObject) {
        if self.authService.logout() {
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
        
        //print error?
    }
    
    // For disabling interaction with the front view while the slide out menu is visible
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.left {
            self.tableView.isScrollEnabled = true
            
            for view in self.tableView.subviews {
                view.isUserInteractionEnabled = true
            }
        }
        else if position == FrontViewPosition.right {
            self.tableView.isScrollEnabled = false
            
            for view in self.tableView.subviews {
                view.isUserInteractionEnabled = false
            }
        }
    }
}

//table view extension
extension MyCoursesTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.myCoursesReuseId, for: indexPath) as! MyCoursesTableViewCell
        
        cell.course = courses[indexPath.row]

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CourseDetailSegue" {
            if let cell = sender as? MyCoursesTableViewCell {
                let toVC = segue.destination as! CourseViewController
                toVC.course = cell.course
            }
        }
    }
}
