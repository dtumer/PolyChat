//
//  CoursesChatRoomsFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 7/30/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class CoursesChatRoomsFactory {
    class func getCoursesChatRoomsService(serviceKey: String) -> CoursesChatRoomsServiceProtocol {
        switch serviceKey {
        case Constants.FIREBASE_SERVICE_KEY:
            return FirebaseCoursesChatRoomsService()
        default:
            return MockCoursesChatRoomsService()
        }
    }
}
