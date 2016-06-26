//
//  FirebaseUserService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Firebase

class FirebaseUserService: UserServiceProtocol {
    let userRef = FIRDatabase.database().reference()
    
    func getUser(uid: String, callback: (User?) -> ()) {
        userRef.child(Constants.usersDBKey).child(uid).observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let value = snapshot.value {
                callback(User(dictionary: value as! NSDictionary))
            }
            
            callback(nil)
        })
    }
    
    func putUser(uid: String?, user: User, callback: (NSError?) -> ()) {
        let key: String = String(getNextAutoIdKeyValue(Constants.usersDBKey))
        let childVals = [
            "\(Constants.usersDBKey)/\(key)": user.toDictionary(),
        ]
        
        self.userRef.updateChildValues(childVals, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                
                return
            }
            
            print("Successfully inserted data!")
        })
    }
    
    private func getNextAutoIdKeyValue(tableName: String) -> String {
        return self.userRef.child(tableName).childByAutoId().key
    }
}