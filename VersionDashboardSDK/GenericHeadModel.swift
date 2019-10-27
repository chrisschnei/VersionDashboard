//
//  GenericHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.04.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

/**
 Class GenericHeadModel.
 Represents a model containing webservice vendor details.
 */
open class GenericHeadModel: GenericHeadModelProtocol {
    
    /**
     Variable headVersion.
     Contains vendor head version.
     */
    open var headVersion = String()
    
    /**
     Variable name.
     Contains webservice name.
     */
    open var name = String()
    
    /**
     Variable type.
     Contains webservice type.
     */
    open var type = String()
    
    /**
     Variable creationDate.
     Contains plist creation date.
     */
    open var creationDate = Date()
    
    /**
     Variable lastRefresh.
     Contains last update date.
     */
    open var lastRefresh = Date()
    
    /**
     Saves a config file to disc.
     
     - Parameters:
     - filename: String containing file location
     - Returns: true if file is written successfully or false on failure
     */
    init(headVersion: String, name: String, type: String, creationDate: Date, lastRefresh: Date) {
        self.headVersion = headVersion
        self.name = name
        self.type = type
        self.creationDate = creationDate
        self.lastRefresh = lastRefresh
    }

    /**
     Renames plist file on name change.
     
     - Parameters:
     - oldName: old filename.
     - Returns: true if file is renamed successfully or false on failure
     */
    open func renamePlistFile(_ oldName: String) -> Bool {
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: (Constants.headPlistFilesPath + oldName), toPath: (Constants.headPlistFilesPath + self.name))
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return false
        }
        return true
    }
    
    /**
     Deletes a head plist file from database directory.
     
     - Parameters:
     - filename: String containing filename to be deleted.
     - Returns: true if file is deleted successfully or false on failure
     */
    public static func deleteFile(_ filename: String) -> Bool {
        let path = (Constants.headPlistFilesPath + filename)
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Error deleting plist file: \(error)")
            return false
        }
        
        return true
    }
    
    /**
     Saves a config file to disc.
     
     - Parameters:
     - filename: String containing file location
     - Returns: true if file is written successfully or false on failure
     */
    open func saveConfigfile(filename: String) -> Bool {
        let path = Constants.headPlistFilesPath + filename
        let dict: NSMutableDictionary = NSMutableDictionary()
        
        self.lastRefresh = Date()
        
        dict.setObject(self.name, forKey: "name" as NSCopying)
        dict.setObject(self.type, forKey: "type" as NSCopying)
        dict.setObject(self.headVersion, forKey: "headVersion" as NSCopying)
        dict.setObject(self.creationDate, forKey: "creationDate" as NSCopying)
        dict.setObject(self.lastRefresh, forKey: "lastRefresh" as NSCopying)
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return dict.write(toFile: path, atomically: true)
    }
    
    /**
     Updates variable lastRefresh with current timestamp.
     
     - Returns: none
     */
    open func updateDate() -> Void {
        self.lastRefresh = Date()
    }
    
    /**
     Retrieves version from instance. Call this method on specific instance type object.
     
     - Returns: false
     */
    public func getVersion(forceUpdate: Bool) -> Bool {
        print("Call getVersion() function in specific object.")
        return false
    }
    
}
