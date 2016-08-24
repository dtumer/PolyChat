//
//  CourseTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/25/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //move this to constants
    static let subViewEmbedSegueId = "SubViewEmbedSegue"
    
    //sub view manager
    var subViewController: SubViewController!
    
    //the current course
    var course: Course! {
        didSet {
            self.title = course.name
        }
    }
    
    /* CollectionView variables */
    @IBOutlet weak var menuCollectionView: UICollectionView!
    
    var menuItems = [
        "Chat",
        "Groups",
        "Members",
        "Settings",
    ]

    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create navigation button
        setupNavBar()
        
        self.menuCollectionView.selectItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .Left)
    }
    
    //sets up the navigation bar
    private func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(CourseViewController.createMessagePressed))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    //action for when the create message button is pressed
    func createMessagePressed(sender: AnyObject?) {
        self.performSegueWithIdentifier(Constants.createChatSegueId, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CourseViewController.subViewEmbedSegueId {
            self.subViewController = segue.destinationViewController as! SubViewController
            self.subViewController.course = self.course
        }
        else if segue.identifier == Constants.createChatSegueId {
            if let vc = segue.destinationViewController as? UINavigationController {
                let subVCS = vc.viewControllers
                
                if subVCS.count > 0 {
                    if let subVC = subVCS[0] as? CreateChatRoomViewController {
                        subVC.course = self.course
                    }
                }
            }
        }
    }
}

//extension on the course view controller for the collection view menu
extension CourseViewController {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.menuReuseId, forIndexPath: indexPath) as! MenuCollectionViewCell
        
        cell.itemTitleLabel.text = menuItems[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        _ = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.menuReuseId, forIndexPath: indexPath) as! MenuCollectionViewCell
        
        self.subViewController.changeSubView(self.menuItems[indexPath.row])
    }
}

//cell class for the menu bar
class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    override var selected: Bool {
        didSet {
            self.contentView.backgroundColor = selected ? UIColor.blueColor(): nil
        }
    }
}

//extension CourseViewController {
//    //change this to number of sections (3 max)
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    //returns number of rows in section
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.coursesReuseId)!
//        
//        return cell
//    }
//}