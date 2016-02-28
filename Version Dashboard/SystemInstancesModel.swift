//
//  SystemInstancesModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class SystemInstancesModel {
    
    func checkAllInstancesVersions() -> Bool {
        return true
    }
    
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