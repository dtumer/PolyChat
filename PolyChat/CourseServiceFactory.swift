//
//  CourseFactory.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class CourseServiceFactory {
    class var sharedInstance: CourseServiceProtocol! {
        struct Singleton {
            static let instance = CourseServiceFactory.getCourseService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getCourseService(_ serviceKey: String) -> CourseServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseCourseService()
        default:
            return FirebaseCourseService()
        }
    }
}
