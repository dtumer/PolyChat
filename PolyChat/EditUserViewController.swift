//
//  AddUserViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/26/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController, UITextFieldDelegate {
    
    var userService: UserServiceProtocol!
    var authService: AuthServiceProtocol!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var notificationsTextField: UITextField!
    @IBOutlet weak var anonymousTextField: UITextField!
    @IBOutlet weak var userCoursesEditTableView: UITableView!
    
    var user: User!
    var userCourses: [Course]!

    override func viewDidLoad() {
        super.viewDidLoad()
        userService = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
        authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        
        setUserTextFields()
        self.userCoursesEditTableView.setEditing(true, animated: true)
    }
    
    private func setUserTextFields() {
        emailLabel.text = user.email
        nameTextField.text = user.name
        roleTextField.text = user.role.description
        notificationsTextField.text = user.notifications.description
        anonymousTextField.text = user.is_anonymous.description
    }
    
    // Update the user from the text fields when save button is pressed
    @IBAction func savePressed(sender: UIBarButtonItem) {
        user.name = nameTextField.text!
        if let role = Int(roleTextField.text!) {
            user.role = role
        }
        if let notifications = GlobalUtilities.stringToBool(notificationsTextField.text!) {
            user.notifications = notifications
        }
        if let anonymous = GlobalUtilities.stringToBool(anonymousTextField.text!) {
            user.is_anonymous = anonymous
        }
        
        // Update the user in the database
        userService.putUser(user.id, user: user, callback: { error in
            if let error = error {
                print(error)
            }
        })
        
        navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(false)
    }
    
    // UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension EditUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Add one to account for add course cell
        return userCourses.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Cell is a course if row is within the count of courses
        if indexPath.row < userCourses.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.userCourseAdminEditReuseId) as! CoursesAdminTableViewCell
            cell.course = userCourses[indexPath.row]
            return cell
        } else { // Otherwise, cell is an add course cell
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.userCourseAdminAddReuseId)!
            return cell
        }
    }
    
    // Support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Only rows with courses can be editable
        return indexPath.row < userCourses.count
    }
    
    // Support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            userCourses.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.userCoursesAdminSectionHeader
    }
    
}