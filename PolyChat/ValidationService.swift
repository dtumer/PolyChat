//
//  ValidationService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

class ValidationService {
    
    //returns true/false depending on if email is a valid email
    class func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(email)
    }
    
    
}