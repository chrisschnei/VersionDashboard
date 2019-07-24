//
//  HeadInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class HeadInstancesModel : NSObject {
    
    /**
     Load configuration files and create a object for every file.
     
     - Returns: true on success, false on error
     */
    public static func loadConfigfiles() -> Bool {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: Constants.headPlistFilesPath, isDirectory:&isDir) {
            if isDir.boolValue {
                let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: Constants.headPlistFilesPath)!
                
                while let element = enumerator.nextObject() as? String {
                    if element.hasSuffix("plist") {
                        let myDict = NSDictionary(contentsOfFile: Constants.headPlistFilesPath + element)
                        if myDict!["type"] as! String == "Joomla" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = JoomlaHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Joomla", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        } else if myDict!["type"] as! String == "Wordpress" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = WordpressHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Wordpress", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        } else if myDict!["type"] as! String == "Owncloud" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = OwncloudHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Owncloud", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        } else if myDict!["type"] as! String == "Piwik" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = PiwikHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Piwik", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        }
                    }
                }
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: Constants.applicationSupportPath, withIntermediateDirectories: false, attributes: nil)
                try FileManager.default.createDirectory(atPath: Constants.applicationSupportAppname, withIntermediateDirectories: false, attributes: nil)
                try FileManager.default.createDirectory(atPath: Constants.headPlistFilesPath, withIntermediateDirectories: false, attributes: nil)
                try fileManager.copyItem(atPath: Constants.appBundleJoomlaPath, toPath: Constants.joomlaFilePath)
                try fileManager.copyItem(atPath: Constants.appBundlewordpressPath, toPath: Constants.wordpressFilePath)
                try fileManager.copyItem(atPath: Constants.appBundleOwncloudPath, toPath: Constants.owncloudFilePath)
                try fileManager.copyItem(atPath: Constants.appBundlePiwikPath, toPath: Constants.piwikFilePath)
            } catch _ as NSError {
                NSLog("plist folder Application Support headPlistFolder creation failed")
                return false
            }
        }
        
        return true
    }
    
}
