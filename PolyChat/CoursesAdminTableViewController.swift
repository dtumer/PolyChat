//
//  CoursesAdminTableViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CoursesAdminTableViewController: UITableViewController {

    var courseService = CourseServiceFactory.sharedInstance
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCourses()
    }
    
    fileprivate func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CoursesAdminTableViewController.addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addButtonPressed() {
        let storyboard = UIStoryboard(name: "AddCourse", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addCourseViewController")
        let navController = UINavigationController.init(rootViewController:vc)
        self.present(navController, animated: true, completion: nil)
    }
    
    /* Loads all the courses. TODO implement spinner for loading times */
    fileprivate func loadCourses() {
        courseService?.getAllCourses({ (courses, error) in
            if let courses = courses {
                self.courses = courses
                self.tableView.reloadData()
            }
            else {
                print(error)
            }
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

/* Extension to impolement table view for the Admin Courses manager */
extension CoursesAdminTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.coursesReuseId, for: indexPath) as! CoursesAdminTableViewCell
        
        cell.course = courses[indexPath.row]
        
        return cell
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let courseToRemove = self.courses[indexPath.row]
            
            self.courses.remove(at: indexPath.row)
            self.courseService?.removeCourse(courseToRemove, callback: { error in
                //TODO make this log and display differently
                if let error = error {
                    print(error)
                }
                else {
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            })
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
}
