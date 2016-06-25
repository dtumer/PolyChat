//
//  DataServiceDelegate.swift
//  PolyChat
//
//  Created by Deniz Tumer on 6/24/16.
//  Copyright © 2016 DenFan. All rights reserved.
//

protocol DataServiceProtocol {
    //returns all data associated with the specified "table key"
    func listData(tableKey: String)
    
    /* Inserts to dataabse with specified id
     * If no id specified, one will be auto generated
    */
    func insertData(tableName: String, id: String?, data: AnyObject) -> String?
    
    func updateData(tableName: String, dataId: String, newData: AnyObject)
    func removeData(tableName: String, dataId: String)
}
