//
//  UsersSelectTableViewCell.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/31/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class UsersSelectTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User! {
        didSet {
            usernameLabel.text = user.name
        }
    }
}
