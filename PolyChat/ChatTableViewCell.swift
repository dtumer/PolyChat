//
//  ChatTableViewCell.swift
//  PolyChat
//
//  Created by Deniz Tumer on 8/10/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var chatRoomTitleLabel: UILabel!
    
    var chatRoom: ChatRoom! {
        didSet {
            self.chatRoomTitleLabel.text = chatRoom.name
        }
    }
}
