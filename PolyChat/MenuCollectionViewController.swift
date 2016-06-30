//
//  MenuCollectionViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/29/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class MenuCollectionViewController: UICollectionViewController {

    var menuItems = [
        "Chat",
        "Members",
        "Groups",
        "Settings",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//extension with collection view controller data source functions
extension MenuCollectionViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.menuReuseId, forIndexPath: indexPath) as! MenuCollectionViewCell
    
        cell.itemTitleLabel.text = menuItems[indexPath.row]
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("HERE")
    }
}
