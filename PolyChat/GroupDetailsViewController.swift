//
//  GroupDetailsViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/28/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var groupNameLabel: UITextField!
    @IBOutlet weak var editTableButton: UIButton!
    
    var authService: AuthServiceProtocol!
    
    var course: Course!     //course reference
    var group: Group!       //group reference
    var user: User!         //logged in user object
    
    var members: [User] = [] //members in the group
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        initServices()
    }
    
    //view did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //initializes services
    func initServices() {
        self.authService = AuthServiceFactory.sharedInstance
    }
}

extension GroupDetailsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.usersReuseId, for: indexPath)
        
        return cell
    }

}
