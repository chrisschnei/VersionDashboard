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
                var files = Array<String>()
                do {
                    files = try fileManager.contentsOfDirectory(atPath: Constants.headPlistFilesPath)
                } catch _ as NSError {
                    NSLog("Could not get contents of directory \(Constants.headPlistFilesPath).")
                    return false
                }
                if (files.count != 5) {
                    if (!copyHeadPlistFiles()) {
                        NSLog("Copying head plist files failed.")
                        return false
                    }
                }
                
                let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: Constants.headPlistFilesPath)!
                while let element = enumerator.nextObject() as? String {
                    if element.hasSuffix("plist") {
                        let myDict = NSDictionary(contentsOfFile: Constants.headPlistFilesPath + element)
                        if myDict!["type"] as! String == "Joomla" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = JoomlaHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Joomla", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date, downloadurl: myDict?["downloadurl"] as? String ?? "")
                        } else if myDict!["type"] as! String == "Wordpress" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = WordpressHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Wordpress", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date, downloadurl: myDict?["downloadurl"] as? String ?? "")
                        } else if myDict!["type"] as! String == "Owncloud" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = OwncloudHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Owncloud", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date, downloadurl: myDict?["downloadurl"] as? String ?? "")
                        } else if myDict!["type"] as! String == "Piwik" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = PiwikHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Piwik", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date, downloadurl: myDict?["downloadurl"] as? String ?? "")
                        } else if myDict!["type"] as! String == "Nextcloud" {
                            HeadInstances.headInstances[myDict!["name"] as! String] = NextcloudHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Nextcloud", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date, downloadurl: myDict?["downloadurl"] as? String ?? "")
                        }
                    }
                }
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: Constants.applicationSupportAppname, withIntermediateDirectories: false, attributes: nil)
                try FileManager.default.createDirectory(atPath: Constants.headPlistFilesPath, withIntermediateDirectories: false, attributes: nil)
            } catch _ as NSError {
                NSLog("plist folder Application Support headPlistFolder creation failed")
                return false
            }
            if (!copyHeadPlistFiles()) {
                NSLog("Copying head plist files failed.")
                return false
            }
        }
        
        return true
    }
    
    /**
     Copy head plist files.
     
     - Returns: true on success, false on error.
     */
    public static func copyHeadPlistFiles() -> Bool {
        let fileManager = FileManager.default
        do {
            if (!fileManager.fileExists(atPath: Constants.joomlaFilePath)) {
                try fileManager.copyItem(atPath: Constants.appBundleJoomlaPath, toPath: Constants.joomlaFilePath)
            } else if (!fileManager.fileExists(atPath: Constants.wordpressFilePath)) {
                try fileManager.copyItem(atPath: Constants.appBundlewordpressPath, toPath: Constants.wordpressFilePath)
            } else if (!fileManager.fileExists(atPath: Constants.owncloudFilePath)) {
                try fileManager.copyItem(atPath: Constants.appBundleOwncloudPath, toPath: Constants.owncloudFilePath)
            } else if (!fileManager.fileExists(atPath: Constants.piwikFilePath)) {
                try fileManager.copyItem(atPath: Constants.appBundlePiwikPath, toPath: Constants.piwikFilePath)
            } else if (!fileManager.fileExists(atPath: Constants.nextcloudFilePath)) {
                try fileManager.copyItem(atPath: Constants.appBundleNexcloudPath, toPath: Constants.nextcloudFilePath)
            }
        } catch _ as NSError {
            NSLog("plist copying failed.")
            return false
        }
        
        return true
    }
    
}
