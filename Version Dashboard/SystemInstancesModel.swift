//
//  SystemInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class SystemInstancesModel {
    
    func checkAllInstancesVersions(completionHandler: (Bool) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            for instance in systemInstances.keys {
                if((systemInstances[instance] as? JoomlaModel) != nil) {
                    let joomlamodel = systemInstances[instance] as? JoomlaModel
                    //Remote Version url
                    joomlamodel!.getVersions()
                    joomlamodel!.updateDate()
                    joomlamodel!.saveConfigfile()
                } else if((systemInstances[instance] as? PiwikModel) != nil) {
                    let piwikmodel = systemInstances[instance] as? PiwikModel
                    //Remote Version url
                    piwikmodel!.getVersions()
                    piwikmodel!.updateDate()
                    piwikmodel!.saveConfigfile()
                } else if((systemInstances[instance] as? OwncloudModel) != nil) {
                    let owncloudmodel = systemInstances[instance] as? OwncloudModel
                    //Remote Version url
                    owncloudmodel!.getVersions()
                    owncloudmodel!.updateDate()
                    owncloudmodel!.saveConfigfile()
                } else if((systemInstances[instance] as? WordpressModel) != nil) {
                    let wordpressmodel = systemInstances[instance] as? WordpressModel
                    //Remote Version url
                    wordpressmodel!.getVersions()
                    wordpressmodel!.updateDate()
                    wordpressmodel!.saveConfigfile()
                }
            }
            completionHandler(true)
        }
    }
    
    //Todo implement php check functionality
    func checkAllInstancesPHPVersions() -> String {
        return "5.3"
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