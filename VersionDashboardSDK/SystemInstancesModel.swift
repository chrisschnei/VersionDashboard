//
//  SystemInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class SystemInstancesModel : NSObject {
    
    public static func checkAllInstancesVersions(force: Bool, _ completionHandler: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            for instance in SystemInstances.systemInstances.keys {
                if((SystemInstances.systemInstances[instance] as? JoomlaModel) != nil) {
                    let joomlamodel = SystemInstances.systemInstances[instance] as? JoomlaModel
                    //Remote Version url
                    _ = joomlamodel!.getVersions(forceUpdate: force)
                    _ = joomlamodel!.updateDate()
                    _ = joomlamodel!.checkNotificationRequired()
                    _ = joomlamodel!.saveConfigfile()
                } else if((SystemInstances.systemInstances[instance] as? PiwikModel) != nil) {
                    let piwikmodel = SystemInstances.systemInstances[instance] as? PiwikModel
                    //Remote Version url
                    _ = piwikmodel!.getVersions(forceUpdate: force)
                    _ = piwikmodel!.updateDate()
                    _ = piwikmodel!.checkNotificationRequired()
                    _ = piwikmodel!.saveConfigfile()
                } else if((SystemInstances.systemInstances[instance] as? OwncloudModel) != nil) {
                    let owncloudmodel = SystemInstances.systemInstances[instance] as? OwncloudModel
                    //Remote Version url
                    _ = owncloudmodel!.getVersions(forceUpdate: force)
                    _ = owncloudmodel!.updateDate()
                    _ = owncloudmodel!.checkNotificationRequired()
                    _ = owncloudmodel!.saveConfigfile()
                } else if((SystemInstances.systemInstances[instance] as? WordpressModel) != nil) {
                    let wordpressmodel = SystemInstances.systemInstances[instance] as? WordpressModel
                    //Remote Version url
                    _ = wordpressmodel!.getVersions(forceUpdate: force)
                    _ = wordpressmodel!.updateDate()
                    _ = wordpressmodel!.checkNotificationRequired()
                    _ = wordpressmodel!.saveConfigfile()
                }
            }
            completionHandler(true)
        }
    }
    
    public static func checkAllInstancesTypes() -> Dictionary<String, Int> {
        var wordpressInstances = 0
        var piwikInstances = 0
        var owncloudInstances = 0
        var joomlaInstances = 0
        
        let keys = SystemInstances.systemInstances.keys
        for instanceName in keys {
            if((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                wordpressInstances = wordpressInstances + 1
            } else if((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                joomlaInstances = joomlaInstances + 1
            } else if((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                piwikInstances = piwikInstances + 1
            } else if((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                owncloudInstances = owncloudInstances + 1
            }
        }
        return ["Wordpress" : wordpressInstances, "Joomla" : joomlaInstances, "Owncloud" : owncloudInstances, "Piwik" : piwikInstances]
    }
    
    public static func getAmountOfInstances() -> String {
       return String(SystemInstances.systemInstances.count)
    }
    
    public static func getAmountOfOutdateInstances() -> Int {
        var instancesOutOfDate = 0
        
        let keys = SystemInstances.systemInstances.keys
        for instanceName in keys {
            if((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! WordpressModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! JoomlaModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! PiwikModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            } else if((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                if(((SystemInstances.systemInstances[instanceName] as! OwncloudModel).updateAvailable) != 0) {
                    instancesOutOfDate = instancesOutOfDate + 1
                }
            }
        }
        return instancesOutOfDate
    }
    
    public static func checkInstanceNameAlreadyPresent(_ newName: String) -> Bool {
        if(SystemInstances.systemInstances[newName] != nil) {
            return true
        }
        return false
    }
    
    public static func loadConfigfiles() {
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
                        }
                        if((myDict!["updateAvailable"] as! Int) == 1) {
//                            incrementBadgeNumber()
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
            }
        }
    }
    
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
            }
        }
        return instancesUptoDate
    }
    
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
            }
        }
        return outdatedInstances
    }
}
