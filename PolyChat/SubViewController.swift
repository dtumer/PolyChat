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
        self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: self)
    }
    
    // Changes the current sub view to the one specified by the title
    func changeSubView(_ subViewTitle: String) {
        self.currentSegueIdentifier = "\(subViewTitle)Segue"
        self.performSegue(withIdentifier: self.currentSegueIdentifier, sender: nil)
    }
    
    // Setup the subview as we transition from one view to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setCourse(segue)
        
        if self.childViewControllers.count > 0 {
            presentChildViewController(self.childViewControllers[0], toVC: segue.destination, isSwap: true)
        }
        else {
            presentChildViewController(nil, toVC: segue.destination, isSwap: false)
        }
    }
    
    //sets the course object on the respective view controller
    fileprivate func setCourse(_ segue: UIStoryboardSegue) {
        //if the destination is the chat view
        if let vc = segue.destination as? ChatTableViewController {
            vc.course = self.course
        }
        //if on the members tab
        if let vc = segue.destination as? MembersTableViewController {
            vc.course = self.course
        }
        //if on group tab
        if let vc = segue.destination as? GroupTableViewController {
            vc.course = self.course
        }
    }
    
    fileprivate func presentChildViewController(_ fromVC: UIViewController?, toVC: UIViewController, isSwap: Bool) {
        toVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        if isSwap {
            fromVC!.willMove(toParentViewController: nil)
            self.addChildViewController(toVC)
            self.transition(from: fromVC!, to: toVC, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: { (finished) in
                fromVC!.removeFromParentViewController()
                toVC.didMove(toParentViewController: self)
            })
        }
        else {
            self.addChildViewController(toVC)
            self.view.addSubview(toVC.view)
            toVC.didMove(toParentViewController: self)
        }
    }
}
