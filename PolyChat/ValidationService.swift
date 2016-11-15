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
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    //returns whether or not a password is valid
    class func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty && password.characters.count >= 8
    }
}
