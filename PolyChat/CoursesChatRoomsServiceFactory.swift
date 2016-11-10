//
//  CoursesChatRoomsFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class CoursesChatRoomsServiceFactory {
    class var sharedInstance: CoursesChatRoomsServiceProtocol! {
        struct Singleton {
            static let instance = CoursesChatRoomsServiceFactory.getCoursesChatRoomsService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getCoursesChatRoomsService(_ serviceKey: String) -> CoursesChatRoomsServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseCoursesChatRoomsService()
        default:
            return FirebaseCoursesChatRoomsService()
        }
    }
}
