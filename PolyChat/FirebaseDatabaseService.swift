//
//  FirebaseDatabaseService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDatabaseService {
    let dbRef = FIRDatabase.database().reference()
    var handles: [UInt] = []
    
    /* Gets the next ID in the given firebase table */ 
    func getAutoId(tableKey: String) -> String {
        return dbRef.child(tableKey).childByAutoId().key
    }
    
    //Closes all handles that are open
    func closeAllHandles() {
        for handle in handles {
            dbRef.removeObserverWithHandle(handle)
        }
    }
}