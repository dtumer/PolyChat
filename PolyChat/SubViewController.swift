//
//  SubViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {
    static let chatSegueId = "ChatSegue"
    static let groupsSegueId = "GroupsSegue"
    static let membersSegueId = "MembersSegue"
    static let settingsSegueId = "SettingsSegue"
    
    var currentSegueIdentifier: String!
    var course: Course!
    
    //on startup of the custome subview container
    override func viewDidLoad() {
        super.viewDidLoad()

        //initialize chat view first
        self.currentSegueIdentifier = SubViewController.chatSegueId
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: self)
    }
    
    // Changes the current sub view to the one specified by the title
    func changeSubView(subViewTitle: String) {
        self.currentSegueIdentifier = "\(subViewTitle)Segue"
        self.performSegueWithIdentifier(self.currentSegueIdentifier, sender: nil)
    }
    
    // Setup the subview as we transition from one view to another
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        setCourse(segue)
        
        if self.childViewControllers.count > 0 {
            presentChildViewController(self.childViewControllers[0], toVC: segue.destinationViewController, isSwap: true)
        }
        else {
            presentChildViewController(nil, toVC: segue.destinationViewController, isSwap: false)
        }
    }
    
    //sets the course object on the respective view controller
    private func setCourse(segue: UIStoryboardSegue) {
        //if the destination is the chat view
        if let vc = segue.destinationViewController as? ChatTableViewController {
            vc.course = self.course
        }
        //if on the members tab
        //if on group tab
        //if on settings tab
    }
    
    private func presentChildViewController(fromVC: UIViewController?, toVC: UIViewController, isSwap: Bool) {
        toVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        if isSwap {
            fromVC!.willMoveToParentViewController(nil)
            self.addChildViewController(toVC)
            self.transitionFromViewController(fromVC!, toViewController: toVC, duration: 0.25, options: .TransitionCrossDissolve, animations: nil, completion: { (finished) in
                fromVC!.removeFromParentViewController()
                toVC.didMoveToParentViewController(self)
            })
        }
        else {
            self.addChildViewController(toVC)
            self.view.addSubview(toVC.view)
            toVC.didMoveToParentViewController(self)
        }
    }
}
