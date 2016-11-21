//
//  GroupTableViewCell.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupTitleLabel: UILabel!
    
    var group: Group! {
        didSet {
            self.groupTitleLabel.text = group.name
        }
    }
}
