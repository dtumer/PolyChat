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
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmView: UIView!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        confirmErrorLabel.isHidden = true
    }
    
    // MARK: Actions
    @IBAction func signUp(_ sender: UIButton) {
        let authService = AuthServiceFactory.sharedInstance
        
        // Validate Email
        if (ValidationService.isValidEmail(emailTextField.text!) && isValidPassword(passwordTextField.text!)) {
            setCorrectEmail()
            setCorrectPassword()
            
            authService?.signUpUser(emailTextField.text! + "@calpoly.edu", passHash: passwordTextField.text!, callback: { error in
                if error != nil {
                    self.emailErrorLabel.isHidden = false
                    self.emailErrorLabel.text = "User with that email already exists"
                    
                    self.emailView.layer.borderColor = UIColor.red.cgColor
                    self.emailView.layer.borderWidth = 1.0
                }
                else {
                    self.emailView.layer.borderWidth = 0.0
                    
                    self.dismiss(animated: true, completion: nil)
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
            
            let validPassword = isValidPassword(passwordTextField.text!)
            let passEqual = isPasswordsEqual(passwordTextField.text!, confirmPass: confirmTextField.text!)
            let isValid = validPassword && passEqual
            
            print(passEqual)
            
            if !validPassword {
                setIncorrectPassword()
            }
            
            if !passEqual {
                setPasswordMismatch()
            }
            
            if isValid {
                setCorrectPassword()
            }
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //checks for valid password
    func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty && password.characters.count >= 8
    }
    
    //checks for equal passwords
    func isPasswordsEqual(_ password: String, confirmPass: String) -> Bool {
        return password == confirmPass
    }
    
    //sets correct email address
    func setCorrectEmail() {
        emailErrorLabel.isHidden = true
        
        emailView.layer.borderWidth = 0.0
    }
    
    //sets incorrect email address
    func setIncorrectEmail() {
        emailErrorLabel.isHidden = false
        
        emailView.layer.borderColor = UIColor.red.cgColor
        emailView.layer.borderWidth = 1.0
    }
    
    //sets incorrect password
    func setIncorrectPassword() {
        passwordErrorLabel.isHidden = false
        
        passwordView.layer.borderColor = UIColor.red.cgColor
        passwordView.layer.borderWidth = 1.0
    }
    
    //sets correct password
    func setCorrectPassword() {
        passwordErrorLabel.isHidden = true
        confirmErrorLabel.isHidden = true
        
        passwordView.layer.borderWidth = 0.0
        confirmView.layer.borderWidth = 0.0
    }
    
    //sets password mismatch
    func setPasswordMismatch() {
        confirmErrorLabel.isHidden = false
        
        confirmView.layer.borderColor = UIColor.red.cgColor
        confirmView.layer.borderWidth = 1.0
    }
}
