//
//  GlobalUtilities.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

class GlobalUtilities {
    /* Retrieves the name of a person from their email (the first part of the email) */
    static func getNameFromEmail(email: String) -> String {
        let emailArr = email.characters.split{$0 == "@"}.map(String.init)
        
        return emailArr[0]
    }
    
    static func stringToBool(str: String) -> Bool? {
        switch str {
        case "TRUE", "True", "true", "yes", "1", "T", "t":
            return true
        case "FALSE", "False", "false", "no", "0", "F", "f":
            return false
        default:
            return nil
        }
    }
    
    static func isBlankString(text: String) -> Bool {
        let trimmed = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return trimmed.isEmpty
    }
}