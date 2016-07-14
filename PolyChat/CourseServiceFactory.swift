//
//  CourseFactory.swift
//  PolyChat
//
//  Created by Bonilla, Stefan on 7/13/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class CourseServiceFactory {
    class func getUserService(serviceKey: String) -> CourseServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseCourseService()
        default:
            return MockCourseService()
        }
    }
}