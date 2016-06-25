//
//  MyCoursesTableViewCell.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class MyCoursesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseNameLabel: UILabel!
    
    var course: Course! {
        didSet {
            courseNameLabel.text = course.name
        }
    }
}
