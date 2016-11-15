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
        
        errorLabel.isHidden = true
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        correctInput()
        
        if (ValidationService.isValidEmail(emailTextField.text!) &&
            ValidationService.isValidPassword(passwordTextField.text!)) {
            correctInput()
            
            authService?.loginUser("\(emailTextField.text!)@calpoly.edu", passHash: passwordTextField.text!, callback: { (error) in
                if error != nil { //error when logging in user
                    self.incorrectInput()
                    return
                }
                else {
                    self.correctInput()
                    self.dismiss(animated: true, completion: nil)
                    
                    return
                }
            })
        }
        else {
            self.incorrectInput()
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //sets ui for incorrect input
    func incorrectInput() {
        self.errorLabel.isHidden = false
        
        self.emailView.layer.borderColor = UIColor.red.cgColor
        self.emailView.layer.borderWidth = 1.0
        
        self.passwordView.layer.borderColor = UIColor.red.cgColor
        self.passwordView.layer.borderWidth = 1.0
    }
    
    //sets ui for correct input
    func correctInput() {
        self.errorLabel.isHidden = true
        
        self.emailView.layer.borderWidth = 0.0
        
        self.passwordView.layer.borderWidth = 0.0
    }
}
