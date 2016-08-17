//
//  ChatRoomViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 8/17/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    
    //chat room object
    var chatRoom: ChatRoom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
    }

    //initializes navigation bar
    private func initNavigation() {
        //sets title to chat room name
        self.navigationItem.title = chatRoom.name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
