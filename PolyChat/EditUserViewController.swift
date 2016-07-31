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
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        userService = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
        authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        
        setUserTextFields()
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
