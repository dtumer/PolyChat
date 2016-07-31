//
//  CreateChatRoomViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CreateChatRoomViewController: UIViewController {

    @IBOutlet weak var chatRoomNameLabel: UITextField!
    
    //services
    var authService: AuthServiceProtocol!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        
        self.navigationController?.navigationBar.translucent = false
    }
    
    //make sure user is logged in
    override func viewDidAppear(animated: Bool) {
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        }
        else {
            print("HERE")
        }
    }
    
    //initializes services needed for this view controller
    private func initServices() {
        self.authService = AuthServiceFactory.getAuthService(Constants.CURRENT_SERVICE_KEY)
    }
    
    //dismiss chat room create when cancel is pressed
    @IBAction func cancelCreatePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.createChatNextSegueId {
            if let vc = segue.destinationViewController as? UserSelectTableViewController {
                vc.chatRoom = ChatRoom(dictionary: [
                    "name": self.chatRoomNameLabel.text!
                ])
            }
        }
    }
}
