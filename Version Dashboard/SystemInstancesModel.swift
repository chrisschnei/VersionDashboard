//
//  SystemInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class SystemInstancesModel : NSObject {
    
    func checkAllInstancesVersions(completionHandler: (Bool) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            for instance in systemInstances.keys {
                if((systemInstances[instance] as? JoomlaModel) != nil) {
                    let joomlamodel = systemInstances[instance] as? JoomlaModel
                    //Remote Version url
                    joomlamodel!.getVersions()
                    joomlamodel!.updateDate()
                    joomlamodel!.checkNotificationRequired()
                    joomlamodel!.saveConfigfile()
                } else if((systemInstances[instance] as? PiwikModel) != nil) {
                    let piwikmodel = systemInstances[instance] as? PiwikModel
                    //Remote Version url
                    piwikmodel!.getVersions()
                    piwikmodel!.updateDate()
                    piwikmodel!.checkNotificationRequired()
                    piwikmodel!.saveConfigfile()
                } else if((systemInstances[instance] as? OwncloudModel) != nil) {
                    let owncloudmodel = systemInstances[instance] as? OwncloudModel
                    //Remote Version url
                    owncloudmodel!.getVersions()
                    owncloudmodel!.updateDate()
                    owncloudmodel!.checkNotificationRequired()
                    owncloudmodel!.saveConfigfile()
                } else if((systemInstances[instance] as? WordpressModel) != nil) {
                    let wordpressmodel = systemInstances[instance] as? WordpressModel
                    //Remote Version url
                    wordpressmodel!.getVersions()
                    wordpressmodel!.updateDate()
                    wordpressmodel!.checkNotificationRequired()
                    wordpressmodel!.saveConfigfile()
                }
            }
            completionHandler(true)
        }
    }
    
    func checkAllInstancesTypes() -> Dictionary<String, Int> {
        var wordpressInstances = 0
        var piwikInstances = 0
        var owncloudInstances = 0
        var joomlaInstances = 0
        
        let keys = systemInstances.keys
        for instanceName in keys {
            if((systemInstances[instanceName] as? WordpressModel) != nil) {
                wordpressInstances = wordpressInstances + 1
            } else if((systemInstances[instanceName] as? JoomlaModel) != nil) {
                joomlaInstances = joomlaInstances + 1
            } else if((systemInstances[instanceName] as? PiwikModel) != nil) {
                piwikInstances = piwikInstances + 1
            } else if((systemInstances[instanceName] as? OwncloudModel) != nil) {
                owncloudInstances = owncloudInstances + 1
            }
        }
        return ["Wordpress" : wordpressInstances, "Joomla" : joomlaInstances, "Owncloud" : owncloudInstances, "Piwik" : piwikInstances]
    }
    
    func getAmountOfInstances() -> String {
       return String(systemInstances.count)
    }
    
    func getAmountOfOutdateInstances() -> Int {
        var instancesOutOfDate = 0
        
        let keys = systemInstances.keys
        for instanceName in keys {
            if((systemInstances[instanceName] as? WordpressModel) != nil) {
                if(((systemInstances[instanceName] as! WordpressModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            } else if((systemInstances[instanceName] as? JoomlaModel) != nil) {
                if(((systemInstances[instanceName] as! JoomlaModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            } else if((systemInstances[instanceName] as? PiwikModel) != nil) {
                if(((systemInstances[instanceName] as! PiwikModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            } else if((systemInstances[instanceName] as? OwncloudModel) != nil) {
                if(((systemInstances[instanceName] as! OwncloudModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            }
        }
        return instancesOutOfDate
    }
    
    func checkInstanceNameAlreadyPresent(newName: String) -> Bool {
        if(systemInstances[newName] != nil) {
            return true
        }
        return false
    }
    
    func loadConfigfiles() {
        let fileManager = NSFileManager.defaultManager()
        var isDir : ObjCBool = false
        if fileManager.fileExistsAtPath(plistFilesPath, isDirectory:&isDir) {
            if isDir {
                let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(plistFilesPath)!
                zeroBadgeNumber()
                
                while let element = enumerator.nextObject() as? String {
                    if element.hasSuffix("plist") {
                        let myDict = NSDictionary(contentsOfFile: plistFilesPath.stringByAppendingString(element))
                        if myDict!["type"] as! String == "Joomla" {
                            systemInstances[myDict!["name"] as! String] = JoomlaModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Wordpress" {
                            systemInstances[myDict!["name"] as! String] = WordpressModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Owncloud" {
                            systemInstances[myDict!["name"] as! String] = OwncloudModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Piwik" {
                            systemInstances[myDict!["name"] as! String] = PiwikModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, apiToken: myDict!["apiToken"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        }
                        if((myDict!["updateAvailable"] as! Int) == 1) {
                            incrementBadgeNumber()
                        }
                    }
                }
            }
        } else {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(applicationSupportAppNameURL, withIntermediateDirectories: false, attributes: nil)
                try NSFileManager.defaultManager().createDirectoryAtPath(plistFilesPath, withIntermediateDirectories: false, attributes: nil)
            } catch _ as NSError {
                NSLog("plist folder Application Support creation failed")
            }
        }
    }
    
    func getAmountOfUptodateInstances() -> Int {
        var instancesUptoDate = 0
        
        let keys = systemInstances.keys
        for instanceName in keys {
            if((systemInstances[instanceName] as? WordpressModel) != nil) {
                if(((systemInstances[instanceName] as! WordpressModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            } else if((systemInstances[instanceName] as? JoomlaModel) != nil) {
                if(((systemInstances[instanceName] as! JoomlaModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            } else if((systemInstances[instanceName] as? PiwikModel) != nil) {
                if(((systemInstances[instanceName] as! PiwikModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            } else if((systemInstances[instanceName] as? OwncloudModel) != nil) {
                if(((systemInstances[instanceName] as! OwncloudModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            }
        }
        return instancesUptoDate
    }
}