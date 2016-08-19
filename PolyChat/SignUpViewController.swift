//
//  SignUpViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Actions
    @IBAction func signUp(sender: UIButton) {
        let authService = AuthServiceFactory.sharedInstance
        
        // Validate Email
        if ValidationService.isValidEmail(emailTextField.text!) {
            // Email is valid
            authService?.signUpUser(emailTextField.text!, passHash: passwordTextField.text!)
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        // invalid email
        print("INVALID EMAIL")
    }
    
    //dismisses sign up view controller
    @IBAction func cancelSignUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
