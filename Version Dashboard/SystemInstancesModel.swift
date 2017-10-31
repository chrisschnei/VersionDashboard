//
//  SystemInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class SystemInstancesModel : NSObject {
    
    func checkAllInstancesVersions(force: Bool, _ completionHandler: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            for instance in systemInstances.keys {
                if((systemInstances[instance] as? JoomlaModel) != nil) {
                    let joomlamodel = systemInstances[instance] as? JoomlaModel
                    //Remote Version url
                    _ = joomlamodel!.getVersions(forceUpdate: force)
                    _ = joomlamodel!.updateDate()
                    _ = joomlamodel!.checkNotificationRequired()
                    _ = joomlamodel!.saveConfigfile()
                } else if((systemInstances[instance] as? PiwikModel) != nil) {
                    let piwikmodel = systemInstances[instance] as? PiwikModel
                    //Remote Version url
                    _ = piwikmodel!.getVersions(forceUpdate: force)
                    _ = piwikmodel!.updateDate()
                    _ = piwikmodel!.checkNotificationRequired()
                    _ = piwikmodel!.saveConfigfile()
                } else if((systemInstances[instance] as? OwncloudModel) != nil) {
                    let owncloudmodel = systemInstances[instance] as? OwncloudModel
                    //Remote Version url
                    _ = owncloudmodel!.getVersions(forceUpdate: force)
                    _ = owncloudmodel!.updateDate()
                    _ = owncloudmodel!.checkNotificationRequired()
                    _ = owncloudmodel!.saveConfigfile()
                } else if((systemInstances[instance] as? WordpressModel) != nil) {
                    let wordpressmodel = systemInstances[instance] as? WordpressModel
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
    
    func checkInstanceNameAlreadyPresent(_ newName: String) -> Bool {
        if(systemInstances[newName] != nil) {
            return true
        }
        return false
    }
    
    func loadConfigfiles() {
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: plistFilesPath, isDirectory:&isDir) {
            if isDir.boolValue {
                let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: plistFilesPath)!
                zeroBadgeNumber()
                
                while let element = enumerator.nextObject() as? String {
                    if element.hasSuffix("plist") {
                        let myDict = NSDictionary(contentsOfFile: plistFilesPath + element)
                        if myDict!["type"] as! String == "Joomla" {
                            let joomlahead = headInstances["Joomla"].self! as! JoomlaHeadModel
                            systemInstances[myDict!["name"] as! String] = JoomlaModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, headVersion: joomlahead.headVersion, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Wordpress" {
                            let wordpresshead = headInstances["Wordpress"].self! as! WordpressHeadModel
                            systemInstances[myDict!["name"] as! String] = WordpressModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, headVersion: wordpresshead.headVersion, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Owncloud" {
                            let owncloudhead = headInstances["Owncloud"].self! as! OwncloudHeadModel
                            systemInstances[myDict!["name"] as! String] = OwncloudModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, headVersion: owncloudhead.headVersion, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        } else if myDict!["type"] as! String == "Piwik" {
                            let piwikhead = headInstances["Piwik"].self! as! PiwikHeadModel
                            systemInstances[myDict!["name"] as! String] = PiwikModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, apiToken: myDict!["apiToken"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: piwikhead.headVersion, updateAvailable: myDict!["updateAvailable"] as! Int, phpVersion: myDict!["phpVersion"] as! String, serverType: myDict!["serverType"] as! String)
                        }
                        if((myDict!["updateAvailable"] as! Int) == 1) {
                            incrementBadgeNumber()
                        }
                    }
                }
            }
        } else {
            do {
                try FileManager.default.createDirectory(atPath: plistFilesPath, withIntermediateDirectories: false, attributes: nil)
                try FileManager.default.createDirectory(atPath: configurationFilePath, withIntermediateDirectories: false, attributes: nil)
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
