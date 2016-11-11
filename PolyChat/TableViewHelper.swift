//
//  TableViewHelper.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/11/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class TableViewHelper {
    class func EmptyMessage(message:String, viewController:UITableViewController) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.size.width, height: viewController.view.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 17)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none;
    }
    
    class func removeEmptyMessage(viewController: UITableViewController) {
        viewController.tableView.backgroundView = nil
    }
}
