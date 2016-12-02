//
//  GroupDetailsTableViewCell.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/28/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class GroupDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    var user: User! {
        didSet {
            usernameLabel.text = user.name
        }
    }
}
