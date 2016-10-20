//
//  LoginViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/29/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var authService: AuthServiceProtocol!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve Auth Service
        self.authService = AuthServiceFactory.sharedInstance
        
        errorLabel.hidden = true
    }
    
    @IBAction func loginPressed(sender: UIButton) {
        if (isValidEmail(emailTextField.text!) && isValidPassword(passwordTextField.text!)) {
            authService?.loginUser("\(emailTextField.text!)@calpoly.edu", passHash: passwordTextField.text!, callback: { (error) in
                if error != nil { //error when logging in user
                    self.incorrectInput()
                    return
                }
                else {
                    self.correctInput()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    return
                }
            })
        }
        else {
            self.incorrectInput()
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    //checks for valid email
    func isValidEmail(email: String) -> Bool {
        if (!email.isEmpty && ValidationService.isValidEmail(email)) {
            return true
        }
        
        return false
    }
    
    //checks for valid password
    func isValidPassword(password: String) -> Bool {
        return password.characters.count >= 8
    }
    
    //sets ui for incorrect input
    func incorrectInput() {
        self.errorLabel.hidden = false
        
        self.emailView.layer.borderColor = UIColor.redColor().CGColor
        self.emailView.layer.borderWidth = 1.0
        
        self.passwordView.layer.borderColor = UIColor.redColor().CGColor
        self.passwordView.layer.borderWidth = 1.0
    }
    
    //sets ui for correct input
    func correctInput() {
        self.errorLabel.hidden = true
        
        self.emailView.layer.borderWidth = 0.0
        
        self.passwordView.layer.borderWidth = 0.0
    }
}
