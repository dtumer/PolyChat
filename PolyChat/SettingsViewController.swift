//
//  SettingsViewController.swift
//  PolyChat
//
//  Created by Stefan Bonilla on 9/28/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, SWRevealViewControllerDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    @IBOutlet weak var anonymousSwitch: UISwitch!
    
    //services variables
    var authService: AuthServiceProtocol!
    
    //logged in user
    var user: User!
    
    //on view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        initServices()
        notificationsSwitch.addTarget(self,
                                      action: #selector(SettingsViewController.notificationsStateChanged(_:)),
                                      for: UIControlEvents.valueChanged)
        
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
                    // Menu needs user information since it varies based on user (username, role, etc.)
                    self.initMenu()
                }
            })
        }
    }
    
    @IBAction func logoutUser(_ sender: AnyObject) {
        _ = self.authService.logout()
        
        self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
    }
    
    //initializes all services needed by this controller
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
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

    func notificationsStateChanged(_ switchState: UISwitch) {
        // TODO: implement notifications
        if switchState.isOn {
            print("Notifications Enabled")
        } else {
            print("Notifications Disabled")
        }
    }
}
