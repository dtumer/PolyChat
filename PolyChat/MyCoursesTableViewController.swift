//
//  MyCoursesTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

//for testing
import Firebase

class MyCoursesTableViewController: UITableViewController {
    
    //services variables
    var authService: AuthServiceProtocol!
    var myCoursesService: MyCoursesServiceProtocol!
    
    //instance variables for UI
    var user: NSDictionary!
    var courses = [Course]()
    var selectedCourse: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initMockData()
        
        //retrieve services we will need
        self.authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        self.myCoursesService = MyCoursesServiceFactory.getMyCoursesService(Constants.CURRENT_SERVICE_KEY)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            //change this to go to login screen
            self.authService.loginUser("dtumer@calpoly.edu", passHash: "17381738", callback: { error in
                if let _ = error {
                    let sb = UIStoryboard(name: "SignUp", bundle: nil)
                    let vc = sb.instantiateViewControllerWithIdentifier("SignUp") as! SignUpViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            })
        }
        
        //get logged in user information
        if let user = self.authService.getUserData() {
            self.user = user
            loadCourses(user["uid"] as! String)
        }
        
    }
    
    //loads the courses from the database
    func loadCourses(uid: String) {
        self.myCoursesService.getEnrolledCourses(uid, callback: { courses in
            if let courses = courses {
                self.courses = courses
                self.tableView.reloadData()
            }
        })
    }
    
    //used to initialize mock data in database
    private func initMockData() {
        let mockInit = FirebaseInitMockDatabase()
    
        mockInit.initMockDB()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.coursesReuseId, forIndexPath: indexPath) as! MyCoursesTableViewCell
        
        cell.course = courses[indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.coursesReuseId, forIndexPath: indexPath) as! MyCoursesTableViewCell
        
        self.selectedCourse = cell.course
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CourseDetailSegue" {
            let toVC = segue.destinationViewController as! CourseTableViewController
            
            toVC.course = self.selectedCourse
        }
    }
}
