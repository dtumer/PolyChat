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
}