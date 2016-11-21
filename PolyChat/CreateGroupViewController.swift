//
//  CreateGroupViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    @IBOutlet weak var groupNameView: UIView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var groupNameErrorLabel: UILabel!
    
    //auth service
    var authService: AuthServiceProtocol!
    
    //user object
    var user: User!
    
    //course object
    var course: Course!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        
        //make sure nav controller is not translucent
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.groupNameErrorLabel.isHidden = true
    }
    
    //make sure user is logged in
    override func viewDidAppear(_ animated: Bool) {
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        }
        else {
            self.authService.getCurrentUser({ (user, error) in
                if let error = error {
                    //TODO show error and go to login
                    print(error.description)
                }
                else {
                    self.user = user!
                }
            })
        }
    }
    
    //inits services
    func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
    }
    
    //handles cancel pressed
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //handles next pressed
    @IBAction func nextScreenPressed(_ sender: AnyObject) {
        //if there is a name continue
        if !(self.groupNameTextField.text?.isEmpty)! {
            self.performSegue(withIdentifier: Constants.createGroupNextSegueId, sender: sender)
        }
            //show error message
        else {
            //set text and make error message appear
            self.groupNameErrorLabel.isHidden = false
            
            //set color of name field border and its width
            self.groupNameView.layer.borderColor = UIColor.red.cgColor
            self.groupNameView.layer.borderWidth = 2.0
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.createGroupNextSegueId {
            if let vc = segue.destination as? UserSelectTableViewController {
                vc.group = Group(dictionary: [
                    "name": self.groupNameTextField.text!
                    ])
                
                vc.course = self.course
                vc.creationMode = Constants.createGroup
            }
        }
    }
}
