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
    
    var subViewController: SubViewController!
    
    //the current course
    var course: Course! {
        didSet {
            self.title = course.name
        }
    }
    
    /* CollectionView variables */
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
    }
    
    //sets up the navigation bar
    private func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: #selector(CourseViewController.createMessagePressed))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    //action for when the create message button is pressed
    func createMessagePressed() {
        print("TODO")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CourseViewController.subViewEmbedSegueId {
            self.subViewController = segue.destinationViewController as! SubViewController
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
        self.subViewController.changeSubView(self.menuItems[indexPath.row])
    }
}

//cell class for the menu bar
class MenuCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemTitleLabel: UILabel!
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