//
//  ChatDetailsViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/21/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ChatDetailsViewController: UIViewController {

    //services
    var authService: AuthServiceProtocol!
    
    //holds reference to chat room
    var chatRoom: ChatRoom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
