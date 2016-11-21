//
//  CoursesGroupsServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 11/20/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class CoursesGroupsServiceFactory {
    class var sharedInstance: CoursesGroupsServiceProtocol! {
        struct Singleton {
            static let instance = CoursesGroupsServiceFactory.getCoursesGroupsService(Constants.CURRENT_SERVICE_KEY)
        }
        
        return Singleton.instance
    }
    
    fileprivate class func getCoursesGroupsService(_ serviceKey: String) -> CoursesGroupsServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseCoursesGroupsService()
        default:
            return FirebaseCoursesGroupsService()
        }
    }
}
