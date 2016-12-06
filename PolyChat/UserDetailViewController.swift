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
            "name": "\(self.selectedUser.name)"
            ])
        
        self.chatRoomService.createChatRoom(self.course.id, users: [self.user, self.selectedUser], chatRoom: chatRoom, callback: { error in
            if let _ = error {
                ConnectivityAlertUtility.alert(viewController: self)
            }
            else {
                //do something
            }
        })
    }
}
