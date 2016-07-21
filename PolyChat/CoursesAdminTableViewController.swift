//
//  CoursesAdminTableViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CoursesAdminTableViewController: UITableViewController {

    var courseService = CourseServiceFactory.getCourseService(Constants.CURRENT_SERVICE_KEY)
    var courses: [Course] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        loadCourses()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    private func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(CoursesAdminTableViewController.addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func addButtonPressed() {
        let storyboard = UIStoryboard(name: "AddCourse", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("addCourseViewController")
        let navController = UINavigationController.init(rootViewController:vc)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    private func loadCourses() {
        courseService.getAllCourses({ (courses, error) in
            print(courses)
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
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.coursesReuseId, forIndexPath: indexPath)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}
