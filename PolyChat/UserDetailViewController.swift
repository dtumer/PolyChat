//
//  UserDetailViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/21/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    
    var authService: AuthServiceProtocol!
    var chatRoomService: ChatRoomServiceProtocol!

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    var user: User!
    var selectedUser: User!
    var course: Course!
    
    var createdChatRoom: ChatRoom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initServices()
        initView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !authService.hasOpenSession() {
            self.performSegue(withIdentifier: Constants.loginSegueId, sender: self)
        } else {
            authService.getCurrentUser({ user, error in
                if let user = user {
                    self.user = user
                } else if let _ = error {
                    ConnectivityAlertUtility.alert(viewController: self)
                }
            })
        }
    }
    
    //initializes view elements
    func initView() {
        self.usernameLabel.text = self.selectedUser.name
        self.emailLabel.text = self.selectedUser.email
    }
    
    //initializes the services we need
    func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
        self.chatRoomService = ChatRoomServiceFactory.sharedInstance
    }
    
    @IBAction func sendDirectMsgPressed(_ sender: Any) {
        let chatRoom = ChatRoom(dictionary: [
            "name": "\(self.selectedUser.name!) & \(self.user.name!)"
            ])
        
        self.chatRoomService.createChatRoom(self.course.id, users: [self.user, self.selectedUser], chatRoom: chatRoom, callback: { (chatRoom, error) in
            if let _ = error {
                ConnectivityAlertUtility.alert(viewController: self)
            }
            else {
                let alert = UIAlertController(title: "Success", message: "Direct message with \(self.selectedUser.name!) created", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}
