//
//  NSErrorExtension.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/27/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

// NSError extension that creates an NSError given a description about the error.
extension NSError {
    convenience init(domain: String, code: Int, description: String) {
        let userInfo = [
            NSLocalizedDescriptionKey: description,
        ]
        
        self.init(domain: domain, code: code, userInfo: userInfo)
    }
}