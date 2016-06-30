//
//  CourseTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/25/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var course: Course! {
        didSet {
            self.title = course.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}