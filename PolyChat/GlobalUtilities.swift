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
    static func getNameFromEmail(_ email: String) -> String {
        let emailArr = email.characters.split{$0 == "@"}.map(String.init)
        
        return emailArr[0]
    }
    
    static func stringToBool(_ str: String) -> Bool? {
        switch str {
        case "TRUE", "True", "true", "yes", "1", "T", "t":
            return true
        case "FALSE", "False", "false", "no", "0", "F", "f":
            return false
        default:
            return nil
        }
    }
    
    static func isBlankString(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    //converts hex strings to byte arrays
    static func hexToByteArray(_ hex: String) -> [UInt8] {
        var ndx = 0
        var byteArr: [UInt8] = []
        
        while ndx < hex.characters.count {
            byteArr.append(UInt8("\(hex[hex.characters.index(hex.startIndex, offsetBy: ndx)])\(hex[hex.characters.index(hex.startIndex, offsetBy: ndx + 1)])", radix: 16)!)
            
            ndx += 2
        }
        
        return byteArr
    }
    
    //converts list of users to list of ids
    static func usersToIds(users: [User]) -> [String] {
        var uids: [String] = []
        
        for user in users {
            uids.append(user.id)
        }
        
        return uids
    }
    
    //calculates set difference A\B
    static func setDifference(A: [String], B: [String]) -> [String] {
        var diff: [String] = []
        
        //b will always be a subset of A
        for elem in A {
            if !B.contains(elem) {
                diff.append(elem)
            }
        }
        
        return diff
    }
}
