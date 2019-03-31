//
//  GenericHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.04.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class GenericHeadModel: GenericHeadModelProtocol {
    
    open var headVersion = String()
    open var name = String()
    open var type = String()
    open var creationDate = Date()
    open var lastRefresh = Date()
    
    init(headVersion: String, name: String, type: String, creationDate: Date, lastRefresh: Date) {
        self.headVersion = headVersion
        self.name = name
        self.type = type
        self.creationDate = creationDate
        self.lastRefresh = lastRefresh
    }

    open func renamePlistFile(_ oldName: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: (plistFilesPath + oldName) + ".plist", toPath: (plistFilesPath + self.name) + ".plist")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    open func saveConfigfile(filename: String) -> Bool {
        let path = headPlistFilesPath + filename
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
    
    open func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.lastRefresh = dateFormatter.date(from: dateFormatter.dateFormat)!
    }
    
}
