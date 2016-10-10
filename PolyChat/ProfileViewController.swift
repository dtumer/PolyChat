//
//  ProfileViewController.swift
//  PolyChat
//
//  Created by Stefan Bonilla on 9/28/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //services variables
    var authService: AuthServiceProtocol!
    var userService: UserServiceProtocol!
    
    //logged in user
    var user: User!
    
    //on view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        initServices()
        
        //makes sure there's no weird grayness happening in the nav bar
        self.navigationController?.navigationBar.translucent = false
    }
    
    //on view did appear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        }
        else {
            //get logged in user information
            self.authService.getCurrentUser({ (user, error) in
                if let error = error {
                    //TODO log error
                    print(error.description)
                }
                else {
                    self.user = user!
                    self.nameTextField.text = self.user.name
                    self.emailTextField.text = self.user.email
                    // Menu needs user information since it varies based on user (username, role, etc.)
                    self.initMenu()
                }
            })
        }
    }
    
    //initializes all services needed by this controller
    private func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.userService = UserServiceFactory.sharedInstance
    }
    
    //initializes the slide out menu
    private func initMenu() {
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let menuVC = self.revealViewController().rearViewController as! MainMenuTableViewController
            menuVC.user = self.user
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard textField.text != nil && !GlobalUtilities.isBlankString(textField.text!) else {
            return
        }
        
        self.user.name = textField.text!
        userService.putUser(self.user.id, user: self.user, callback: { error in
            if let error = error {
                // TODO: Handle this error
                print(error)
            }
        })
    }

}
