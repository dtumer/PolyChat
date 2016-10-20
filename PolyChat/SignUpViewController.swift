//
//  SignUpViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailErrorLabel.hidden = true
        passwordErrorLabel.hidden = true
    }
    
    // MARK: Actions
    @IBAction func signUp(sender: UIButton) {
        let authService = AuthServiceFactory.sharedInstance
        
        // Validate Email
        if (ValidationService.isValidEmail(emailTextField.text!) && isValidPassword(passwordTextField.text!)) {
            setCorrectEmail()
            setCorrectPassword()
            
            authService?.signUpUser(emailTextField.text! + "@calpoly.edu", passHash: passwordTextField.text!, callback: { error in
                if error != nil {
                    self.emailErrorLabel.hidden = false
                    self.emailErrorLabel.text = "User with that email already exists"
                    
                    self.emailView.layer.borderColor = UIColor.redColor().CGColor
                    self.emailView.layer.borderWidth = 1.0
                }
                else {
                    self.emailView.layer.borderWidth = 0.0
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    return
                }
            })
        }
        else {
            if !ValidationService.isValidEmail(emailTextField.text!) {
                setIncorrectEmail()
            }
            else {
                setCorrectEmail()
            }
            
            if !isValidPassword(passwordTextField.text!) {
                setIncorrectPassword()
            }
            else {
                setCorrectPassword()
            }
        }
    }
    
    //dismisses sign up view controller
    @IBAction func cancelSignUp(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //checks for valid password
    func isValidPassword(password: String) -> Bool {
        return !password.isEmpty && password.characters.count >= 8
    }
    
    //sets correct email address
    func setCorrectEmail() {
        emailErrorLabel.hidden = true
        
        emailView.layer.borderWidth = 0.0
    }
    
    //sets incorrect email address
    func setIncorrectEmail() {
        emailErrorLabel.hidden = false
        
        emailView.layer.borderColor = UIColor.redColor().CGColor
        emailView.layer.borderWidth = 1.0
    }
    
    //sets incorrect password
    func setIncorrectPassword() {
        passwordErrorLabel.hidden = false
        
        passwordView.layer.borderColor = UIColor.redColor().CGColor
        passwordView.layer.borderWidth = 1.0
    }
    
    //sets correct password
    func setCorrectPassword() {
        passwordErrorLabel.hidden = true
        
        passwordView.layer.borderWidth = 0.0
    }
}
