//
//  ConnectivityAlertUtility.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/21/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class ConnectivityAlertUtility {
    class func alert(viewController: UIViewController) {
        let alert = UIAlertController(title: "Oops!", message: "There seems to be a problem processing your request. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    class func alert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
