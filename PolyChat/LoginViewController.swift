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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve Auth Service
        self.authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func loginPressed(sender: UIButton) {
        authService?.loginUser(emailTextField.text!, passHash: passwordTextField.text!, callback: { (error) in
            if let error = error {
                print("THERE WAS AN ERROR LOGING IN THE USER")
                return
            }
            
            let sb = UIStoryboard(name: "MyCourses", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("MyCoursesStoryboard") as! MyCoursesTableViewController
            self.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
