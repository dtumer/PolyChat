//
//  DataServiceFactory.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class DataServiceFactory {
    class func getDataService(serviceKey: String) -> DataServiceProtocol {
        switch serviceKey {
            case Constants.FIREBASE_SERVICE_KEY:
                return FirebaseDataService()
            default:
                return MockDataService()
        }
    }
}
