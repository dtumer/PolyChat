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
    
    @IBOutlet weak var emailTextField: UITextField!
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
        emailTextField.text = user.email
        nameTextField.text = user.name
        roleTextField.text = user.role.description
        notificationsTextField.text = user.notifications.description
        anonymousTextField.text = user.is_anonymous.description
    }
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(false)
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(false)
    }
    
    private func stringToBool(str: String) -> Bool? {
        switch str {
        case "True", "true", "yes", "1", "T", "t":
            return true
        case "False", "false", "no", "0", "F", "f":
            return false
        default:
            return nil
        }
    }

}
