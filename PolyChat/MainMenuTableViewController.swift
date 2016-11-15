//
//  MainMenuTableViewController.swift
//  PolyChat
//
//  Created by Stefan Bonilla on 9/16/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
//  Controller for the slide out main menu on the MyCourses page

import UIKit

class MainMenuTableViewController: UITableViewController {
    
    // Logged in user
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register the nib
        let nib = UINib(nibName: "MainMenuHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "MainMenuHeader")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "MainMenuHeader") as! MainMenuTableSectionHeaderView
        header.usernameLabel.text = user.name
        return header
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
