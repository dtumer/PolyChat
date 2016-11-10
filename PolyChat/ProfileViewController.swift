//
//  ProfileViewController.swift
//  PolyChat
//
//  Created by Stefan Bonilla on 9/28/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate, SWRevealViewControllerDelegate {

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
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    //on view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check if a user is logged in
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
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
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.userService = UserServiceFactory.sharedInstance
    }
    
    //initializes the slide out menu
    fileprivate func initMenu() {
        if (self.revealViewController() != nil) {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let menuVC = self.revealViewController().rearViewController as! MainMenuTableViewController
            menuVC.user = self.user
            self.revealViewController().delegate = self
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
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
    
    // For disabling interaction with the front view while the slide out menu is visible
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPosition.left {
            for view in self.view.subviews {
                view.isUserInteractionEnabled = true
            }
        }
        else if position == FrontViewPosition.right {
            for view in self.view.subviews {
                view.isUserInteractionEnabled = false
            }
        }
    }

}
