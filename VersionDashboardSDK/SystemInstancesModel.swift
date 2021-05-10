//
//  SystemInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class SystemInstancesModel : NSObject {
    
    /**
     Calculates amount of instance objects based on supported types
     
     - Returns: Dictionary with instance name as key and amount of instances as value.
     */
    public static func checkAllInstancesTypes() -> Dictionary<String, Int> {
        var result = Dictionary<String, Int>()
        
        let keys = SystemInstances.systemInstances.keys
        for instanceName in keys {
            if((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                if (result["Wordpress"] == nil) {
                    result["Wordpress"] = 1
                } else {
                    result["Wordpress"] = result["Wordpress"]! + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                if (result["Joomla"] == nil) {
                    result["Joomla"] = 1
                } else {
                    result["Joomla"] = result["Joomla"]! + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                if (result["Piwik"] == nil) {
                    result["Piwik"] = 1
                } else {
                    result["Piwik"] = result["Piwik"]! + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                if (result["Owncloud"] == nil) {
                    result["Owncloud"] = 1
                } else {
                    result["Owncloud"] = result["Owncloud"]! + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? NextcloudModel) != nil) {
                if (result["Nextcloud"] == nil) {
                    result["Nextcloud"] = 1
                } else {
                    result["Nextcloud"] = result["Nextcloud"]! + 1
                }
            }
        }
        return result
    }
    
    /**
     Calculates number of created system instances.
     
     - Returns: Amount of system instances as string value
     */
    public static func getAmountOfInstances() -> String {
       return String(SystemInstances.systemInstances.count)
    }
    
    /**
     Calculates a list of outdated instances.
     
     - Returns: Numer of outdated instances.
     */
    public static func getAmountOfOutdateInstances() -> Int {
        var instancesOutOfDate = 0
        
        let keys = SystemInstances.systemInstances.keys
        for instanceName in keys {
            if((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! WordpressModel).updateAvailable) != 0) {
                    instancesOutOfDate += 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! JoomlaModel).updateAvailable) != 0) {
                    instancesOutOfDate += 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! PiwikModel).updateAvailable) != 0) {
                    instancesOutOfDate += 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! OwncloudModel).updateAvailable) != 0) {
                    instancesOutOfDate += 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? NextcloudModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! NextcloudModel).updateAvailable) != 0) {
                    instancesOutOfDate += 1
                }
            }
        }
        return instancesOutOfDate
    }
    
    /**
     On new instance creation check if name is already present. This is important because name is the primary key and therefor has to be unique in the app.
     
     - Parameters:
     - newName: Name to be created.
     - Returns: true if name already extists, false if name is not used already.
     */
    public static func checkInstanceNameAlreadyPresent(_ newName: String) -> Bool {
        if(SystemInstances.systemInstances[newName] != nil) {
            return true
        }
        return false
    }
    
    /**
     Loads all configurationfiles containing informations about system instances.
     
     - Returns: true on success, false on failure
     */
    public static func loadConfigfiles() -> Bool {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: Constants.plistFilesPath, isDirectory:&isDir) {
            if isDir.boolValue {
                let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: Constants.plistFilesPath)!
                
                while let element = enumerator.nextObject() as? String {
                    if element.hasSuffix("plist") {
                        let myDict = NSDictionary(contentsOfFile: Constants.plistFilesPath + element)
                        if myDict!["type"] as! String == "Joomla" {
                            let joomlahead = HeadInstances.headInstances["Joomla"].self! as! JoomlaHeadModel
                            SystemInstances.systemInstances[myDict!["name"] as! String] = JoomlaModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, headVersion: joomlahead.headVersion, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Wordpress" {
                            let wordpresshead = HeadInstances.headInstances["Wordpress"].self! as! WordpressHeadModel
                            SystemInstances.systemInstances[myDict!["name"] as! String] = WordpressModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, headVersion: wordpresshead.headVersion, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Owncloud" {
                            let owncloudhead = HeadInstances.headInstances["Owncloud"].self! as! OwncloudHeadModel
                            SystemInstances.systemInstances[myDict!["name"] as! String] = OwncloudModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, headVersion: owncloudhead.headVersion, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Piwik" {
                            let piwikhead = HeadInstances.headInstances["Piwik"].self! as! PiwikHeadModel
                            SystemInstances.systemInstances[myDict!["name"] as! String] = PiwikModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, apiToken: myDict!["apiToken"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: piwikhead.headVersion, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Nextcloud" {
                            let nextcloudhead = HeadInstances.headInstances["Nextcloud"].self! as! NextcloudHeadModel
                            SystemInstances.systemInstances[myDict!["name"] as! String] = NextcloudModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, headVersion: nextcloudhead.headVersion, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else {
                            NSLog("HeadInstance files data loading failed")
                            return false
                        }
                    }
                }
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: Constants.plistFilesPath, withIntermediateDirectories: false, attributes: nil)
                try FileManager.default.createDirectory(atPath: Constants.configurationFilePath, withIntermediateDirectories: false, attributes: nil)
            } catch _ as NSError {
                NSLog("plist folder Application Support creation failed")
                return false
            }
        }
        
        return true
    }
    
    /**
     Returns amount of up to date instances.
     
     - Returns: Value of up to date instances.
     */
    public static func getAmountOfUptodateInstances() -> Int {
        var instancesUptoDate = 0
        
        let keys = SystemInstances.systemInstances.keys
        for instanceName in keys {
            if((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! WordpressModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! JoomlaModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! PiwikModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! OwncloudModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? NextcloudModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! NextcloudModel).updateAvailable) == 0) {
                    instancesUptoDate = instancesUptoDate + 1
                }
            }
        }
        return instancesUptoDate
    }
    
    /**
     Returns amount of outdated instances.
     
     - Returns: Dictionary with outdated instance names as values and reference to model object
     */
    public static func getOutdatedInstances() -> Dictionary<String, AnyObject> {
        var outdatedInstances = Dictionary<String, AnyObject>()
        
        let keys = SystemInstances.systemInstances.keys
        for instanceName in keys {
            if((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! WordpressModel).updateAvailable) == 1) {
                    outdatedInstances[instanceName] = SystemInstances.systemInstances[instanceName]
                }
            } else if((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! JoomlaModel).updateAvailable) == 1) {
                    outdatedInstances[instanceName] = SystemInstances.systemInstances[instanceName]
                }
            } else if((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! PiwikModel).updateAvailable) == 1) {
                    outdatedInstances[instanceName] = SystemInstances.systemInstances[instanceName]
                }
            } else if((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! OwncloudModel).updateAvailable) == 1) {
                    outdatedInstances[instanceName] = SystemInstances.systemInstances[instanceName]
                }
            } else if((SystemInstances.systemInstances[instanceName] as? NextcloudModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! NextcloudModel).updateAvailable) == 1) {
                    outdatedInstances[instanceName] = SystemInstances.systemInstances[instanceName]
                }
            }
        }
        return outdatedInstances
    }
}
