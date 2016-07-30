//
//  AddUserViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/26/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class EditUserViewController: UIViewController, UITextFieldDelegate {
    
    let userService = UserServiceFactory.getUserService(Constants.CURRENT_SERVICE_KEY)
    let authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var notificationsTextField: UITextField!
    @IBOutlet weak var anonymousTextField: UITextField!
    
    //var user: User
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func donePressed(sender: UIBarButtonItem) {
        let email = emailTextField.text!
        let name = nameTextField.text!
        let role = roleTextField.text!
        let notifications: Bool? = stringToBool(notificationsTextField.text!)
        let anonymous: Bool? = stringToBool(anonymousTextField.text!)
        
        let userDict: NSDictionary = ["email" : email, "name": name, "role": role, "notifications": notifications!, "is_anonymous": anonymous!]
        let user = User(dictionary: userDict)
        
//        userService.addUser(course, callback: { error in
//            if let error = error {
//                // Handle error
//                print("ERROR OCCURRED IN ADD COURSE")
//            } else {
//                print("Course \(course.name) added")
//            }
//        })
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelPressed(sender: UIBarButtonItem) {
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
