//
//  UsersAdminTableViewCell.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/26/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class UsersAdminTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
    var user: User! {
        didSet {
            self.userNameLabel.text = user.name
        }
    }
}
