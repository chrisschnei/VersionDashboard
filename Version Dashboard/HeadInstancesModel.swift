//
//  HeadInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class HeadInstancesModel : NSObject {
    
    func loadConfigfiles() {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: headPlistFilesPath, isDirectory:&isDir) {
            if isDir.boolValue {
                let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: headPlistFilesPath)!
                
                while let element = enumerator.nextObject() as? String {
                    if element.hasSuffix("plist") {
                        let myDict = NSDictionary(contentsOfFile: headPlistFilesPath + element)
                        if myDict!["type"] as! String == "Joomla" {
                            headInstances[myDict!["name"] as! String] = JoomlaHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Joomla", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        } else if myDict!["type"] as! String == "Wordpress" {
                            headInstances[myDict!["name"] as! String] = WordpressHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Wordpress", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        } else if myDict!["type"] as! String == "Owncloud" {
                            headInstances[myDict!["name"] as! String] = OwncloudHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Owncloud", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        } else if myDict!["type"] as! String == "Piwik" {
                            headInstances[myDict!["name"] as! String] = PiwikHeadModel(headVersion: myDict!["headVersion"] as! String, name: myDict!["name"] as! String, type: "Piwik", creationDate: myDict!["creationDate"] as! Date, lastRefresh: myDict!["lastRefresh"] as! Date)
                        }
                    }
                }
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: headPlistFilesPath, withIntermediateDirectories: false, attributes: nil)
                try fileManager.copyItem(atPath: appBundleJoomlaPath, toPath: joomlaFilePath)
                try fileManager.copyItem(atPath: appBundlewordpressPath, toPath: wordpressFilePath)
                try fileManager.copyItem(atPath: appBundleOwncloudPath, toPath: owncloudFilePath)
                try fileManager.copyItem(atPath: appBundlePiwikPath, toPath: piwikFilePath)
            } catch _ as NSError {
                NSLog("plist folder Application Support headPlistFolder creation failed")
            }
        }
    }
    
}
