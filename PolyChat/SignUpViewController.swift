//
//  SignUpViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 6/23/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    @IBAction func signUp(sender: UIButton) {
        let authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
        authService?.signUpUser(emailTextField.text!, passHash: passwordTextField.text!)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //dismisses sign up view controller
    @IBAction func cancelSignUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
