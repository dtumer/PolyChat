//
//  CreateGroupViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {
    
    var authService: AuthServiceProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make sure nav controller is not translucent
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
