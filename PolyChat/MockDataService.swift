//
//  MockDataService.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

class MockDataService: DataServiceProtocol {
    func listData(tableKey: String) {
        
    }
    
    func insertData(tableName: String, id: String?, data: AnyObject) -> String? {
        return nil
    }
    
    func removeData(tableName: String, dataId: String) {
        
    }
    
    func updateData(tableName: String, dataId: String, newData: AnyObject) {
        
    }
}
