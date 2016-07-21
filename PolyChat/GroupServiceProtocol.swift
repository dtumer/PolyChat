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
    func getGroup(groupId: String, callback: (Group?, NSError?) -> ())
    
    //get all groups
    func getAllGroups(callback: ([Group]?, NSError?) -> ())
    
    //add group to database
    func addGroup(group: Group, callback: (NSError?) -> ())
}