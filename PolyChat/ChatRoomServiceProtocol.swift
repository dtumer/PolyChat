//
//  ChatRoomServiceProtocol.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/1/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

import Foundation

protocol ChatRoomServiceProtocol {
    func getRoomsWithUser(uid: String, completion: (NSArray?, NSError?) -> ())
}