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
    
    //instance variables for UI
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        
        if !authService.hasOpenSession() {
            self.authService.loginUser("dtumer@calpoly.edu", passHash: "17381738", callback: { error in
                if let _ = error {
                    let sb = UIStoryboard(name: "SignUp", bundle: nil)
                    let vc = sb.instantiateViewControllerWithIdentifier("SignUp") as! SignUpViewController
                    self.presentViewController(vc, animated: true, completion: nil)
                }
            })
        }
        
        //initMockData()
    }
    
    func loadCourses() {
        
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
        
//        cell.course = courses[indexPath.row]

        return cell
    }
}
