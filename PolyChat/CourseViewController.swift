//
//  CourseTableViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/25/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit
import KTCenterFlowLayout

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
    
    let layout = KTCenterFlowLayout()
    
    var menuItems = [
        "Chat",
        "Groups",
        "Members",
    ]

    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create navigation button
        setupNavBar()
        
        //setup layout
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        self.menuCollectionView.collectionViewLayout = layout
        
        self.menuCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .left)
    }
    
    //sets up the navigation bar
    fileprivate func setupNavBar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(CourseViewController.createPressed))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    //action for when the create button is pressed
    func createPressed(_ sender: AnyObject?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Create Chat Room", style: .default, handler: createChatRoom))
        alertController.addAction(UIAlertAction(title: "Create Group", style: .default, handler: createGroup))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //creates a chat room chat
    func createChatRoom(_ sender: UIAlertAction) {
        self.performSegue(withIdentifier: Constants.createChatSegueId, sender: self)
    }
    
    //creates a group
    func createGroup(_ sender: UIAlertAction) {
        self.performSegue(withIdentifier: Constants.createGroupSegueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CourseViewController.subViewEmbedSegueId {
            self.subViewController = segue.destination as! SubViewController
            self.subViewController.course = self.course
        }
        else if segue.identifier == Constants.createChatSegueId {
            if let vc = segue.destination as? UINavigationController {
                let subVCS = vc.viewControllers
                
                if subVCS.count > 0 {
                    if let subVC = subVCS[0] as? CreateChatRoomViewController {
                        subVC.course = self.course
                    }
                }
            }
        }
        else if segue.identifier == Constants.createGroupSegueId {
            if let vc = segue.destination as? UINavigationController {
                let subVCS = vc.viewControllers
                
                if subVCS.count > 0 {
                    if let subVC = subVCS[0] as? CreateGroupViewController {
                        subVC.course = self.course
                    }
                }
            }
        }
    }
}

//extension on the course view controller for the collection view menu
extension CourseViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / CGFloat(self.menuItems.count), height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.menuReuseId, for: indexPath) as! MenuCollectionViewCell
        
        cell.itemTitleLabel.text = menuItems[indexPath.row]
        
        //set up border for cells
        cell.layer.borderColor = UIColor(red: 3/255, green: 86/255, blue: 66/255, alpha: 1).cgColor
        cell.layer.borderWidth = 1.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _ = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.menuReuseId, for: indexPath) as! MenuCollectionViewCell
        
        self.subViewController.changeSubView(self.menuItems[indexPath.row])
    }
}

//cell class for the menu bar
class MenuCollectionViewCell: UICollectionViewCell {
    let selectedColor = UIColor(red: 6/255, green: 86/255, blue: 66/255, alpha: 1)
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.contentView.backgroundColor = isSelected ? selectedColor : nil
        }
    }
}
