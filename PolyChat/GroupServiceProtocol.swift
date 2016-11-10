//
//  GroupServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/18/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol GroupServiceProtocol {
    //get group by id
    func getGroup(_ groupId: String, callback: @escaping (Group?, NSError?) -> ())
    
    //get all groups
    func getAllGroups(_ callback: @escaping ([Group]?, NSError?) -> ())
    
    //add group to database
    func addGroup(_ group: Group, callback: @escaping (NSError?) -> ())
}
