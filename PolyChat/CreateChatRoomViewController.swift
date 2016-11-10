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
    @IBOutlet weak var chatNameView: UIView!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    //auth service for checking login
    var authService: AuthServiceProtocol!
    
    //logged in user object
    var user: User!
    
    //current course object
    var course: Course!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        //hide error label
        self.nameErrorLabel.isHidden = true
    }
    
    //make sure user is logged in
    override func viewDidAppear(_ animated: Bool) {
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        }
        else {
            self.authService.getCurrentUser({ (user, error) in
                if let error = error {
                    //TODO change this to not print
                    print(error.description)
                }
                else {
                    self.user = user!
                }
            })
        }
    }
    
    //initializes services needed for this view controller
    fileprivate func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
    }
    
    //dismiss chat room create when cancel is pressed
    @IBAction func cancelCreatePressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextScreenPressed(_ sender: AnyObject) {
        //if there is a name continue
        if !(self.chatRoomNameField.text?.isEmpty)! {
            self.performSegue(withIdentifier: Constants.createChatNextSegueId, sender: sender)
        }
        //show error message
        else {
            //set text and make error message appear
            self.nameErrorLabel.isHidden = false
            
            //set color of name field border and its width
            self.chatNameView.layer.borderColor = UIColor.red.cgColor
            self.chatNameView.layer.borderWidth = 2.0
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.createChatNextSegueId {
            if let vc = segue.destination as? UserSelectTableViewController {
                vc.chatRoom = ChatRoom(dictionary: [
                    "name": self.chatRoomNameField.text!
                ])
                
                vc.course = self.course
            }
        }
    }
}
