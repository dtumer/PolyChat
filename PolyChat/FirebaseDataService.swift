//
//  FirebaseDataService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDataService: DataServiceProtocol {
    let dataRef = FIRDatabase.database().reference()
    
    func listData(tableKey: String) {
        
    }
    
    //inserts data into the firebase database
    func insertData(tableName: String, id: String?, data: AnyObject) -> String? {
        var key = ""
        
        if let id = id {
            key = id
        }
        else {
            key = getNextAutoIdKeyValue(tableName)
        }
        
        let childVals = [
            "\(tableName)/\(key)": data,
        ]
        var retVal: String? = nil
        
        self.dataRef.updateChildValues(childVals, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                
                return
            }
        
            print("Successfully inserted data!")
            retVal = key
        })
        
        return retVal
    }
    
    func updateData(tableName: String, dataId: String, newData: AnyObject) {
        
    }
    
    func removeData(tableName: String, dataId: String) {
        
    }
    
    //gets autoid keyvalue
    func getNextAutoIdKeyValue(tableName: String) -> String {
        return self.dataRef.child(tableName).childByAutoId().key
    }
}