//
//  CoursesAdminTableViewCell.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/25/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

//TODO rewrite this to use one course cell cause right now there's two classes that have the same code
class CoursesAdminTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseTitle: UILabel!
    
    var course: Course! {
        didSet {
            self.courseTitle.text = course.name
        }
    }
}
