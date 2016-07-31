//
//  ViewUserViewController.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class ViewUserViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var notificationsLabel: UILabel!
    @IBOutlet weak var anonymousLabel: UILabel!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUserLabels()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setUserLabels()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.editUserSegueId {
            let vc = segue.destinationViewController as! EditUserViewController
            vc.user = self.user
        }
    }
    
    private func setUserLabels() {
        emailLabel.text = user.email
        nameLabel.text = user.name
        roleLabel.text = String(user.role)
        notificationsLabel.text = user.notifications.description
        anonymousLabel.text = user.is_anonymous.description
    }

}
