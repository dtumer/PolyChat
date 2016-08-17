//
//  CreateChatRoomViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CreateChatRoomViewController: UIViewController {

    @IBOutlet weak var chatRoomNameField: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    //services
    var authService: AuthServiceProtocol!
    
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        
        self.navigationController?.navigationBar.translucent = false
        
        //hide error label
        self.nameErrorLabel.hidden = true
    }
    
    //make sure user is logged in
    override func viewDidAppear(animated: Bool) {
        if !authService.hasOpenSession() {
            self.performSegueWithIdentifier(Constants.loginSegueId, sender: self)
        }
        else {
            print(course.id)
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
    
    @IBAction func nextScreenPressed(sender: AnyObject) {
        //if there is a name continue
        if !(self.chatRoomNameField.text?.isEmpty)! {
            self.performSegueWithIdentifier(Constants.createChatNextSegueId, sender: sender)
        }
        //show error message
        else {
            //set text and make error message appear
            self.nameErrorLabel.text = "Please name your chat room!"
            self.nameErrorLabel.hidden = false
            
            //set color of name field border and its width
            self.chatRoomNameField.layer.borderColor = UIColor.redColor().CGColor
            self.chatRoomNameField.layer.borderWidth = 2.0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.createChatNextSegueId {
            if let vc = segue.destinationViewController as? UserSelectTableViewController {
                vc.chatRoom = ChatRoom(dictionary: [
                    "name": self.chatRoomNameField.text!
                ])
                
                vc.course = self.course
            }
        }
    }
}
