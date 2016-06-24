//
//  ViewController.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/21/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Actions
    @IBAction func signUp(sender: UIButton) {
        let signUpViewController:SignUpViewController = SignUpViewController()
        
        self.presentViewController(signUpViewController, animated: true, completion: nil)
    }
    

}

