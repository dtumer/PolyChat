//
//  UserServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//
import Foundation

protocol UserServiceProtocol {
    func getUser(uid: String, callback: (User?, NSError?) -> ())
    func getAllUsers(callback: ([User]?, NSError?) -> ())
    func putUser(uid: String?, user: User, callback: (NSError?) -> ())
}