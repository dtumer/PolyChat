//
//  MembersTableViewCell.swift
//  PolyChat
//
//  Created by Deniz Tumer on 8/17/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User! {
        didSet {
            self.userNameLabel.text = user.name
        }
    }
}
