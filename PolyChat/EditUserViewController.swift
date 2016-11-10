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
        userService = UserServiceFactory.sharedInstance
        authService = AuthServiceFactory.sharedInstance
        
        setUserTextFields()
        self.userCoursesEditTableView.setEditing(true, animated: true)
    }
    
    fileprivate func setUserTextFields() {
        emailLabel.text = user.email
        nameTextField.text = user.name
        roleTextField.text = user.role.description
        notificationsTextField.text = user.notifications.description
        anonymousTextField.text = user.is_anonymous.description
    }
    
    // Update the user from the text fields when save button is pressed
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
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
        
        navigationController?.popViewController(animated: false)
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: false)
    }
    
    // UITextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension EditUserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Add one to account for add course cell
        return userCourses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell is a course if row is within the count of courses
        if indexPath.row < userCourses.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userCourseAdminEditReuseId) as! CoursesAdminTableViewCell
            cell.course = userCourses[indexPath.row]
            return cell
        } else { // Otherwise, cell is an add course cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userCourseAdminAddReuseId)!
            return cell
        }
    }
    
    // Support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Both types of cells can be edited (.Insert and .Delete editing styles)
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        // If row is a course, set style to delete
        if indexPath.row < userCourses.count {
            return .delete
        } else { // Row is add row cell, set style to insert
            return .insert
        }
    }
    
    // Support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            userCourses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Constants.userCoursesAdminSectionHeader
    }
    
}
