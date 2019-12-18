//
//  GenericViewController.swift
//  VersionDashboardiOS
//
//  Created by Christian Schneider on 28.04.18.
//  Copyright © 2018 NonameCompany. All rights reserved.
//

import Foundation
import UIKit
#if targetEnvironment(simulator)
import VersionDashboardSDK
#else
import VersionDashboardSDKARM
#endif

class GenericViewController : UIViewController {
    
    func takeMeToMyInstance(_ systemInstanceName : String) -> Bool {
        let instance = SystemInstances.systemInstances[systemInstanceName]
        var url = ""
        if((instance as? JoomlaModel) != nil) {
            url = (instance as! JoomlaModel).hosturl + Constants.joomlaBackendURL
        } else if((instance as? WordpressModel) != nil) {
            url = (instance as! WordpressModel).hosturl + Constants.wordpressBackendURL
        } else if((instance as? PiwikModel) != nil) {
            url = (instance as! PiwikModel).hosturl
        } else if((instance as? OwncloudModel) != nil) {
            url = (instance as! OwncloudModel).hosturl
        }
        UIApplication.shared.open(URL(string: url)!)
        return true
    }
    
    func deleteInstance(_ path: String, _ name: String) -> Bool {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Error deleting plist file: \(error)")
            return false
        }
        SystemInstances.systemInstances.remove(at: SystemInstances.systemInstances.index(forKey: name)!)
        return true
    }
    
    func updateSingleInstance(instanceName: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            var returnValue = true
            if((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                let joomlamodel = SystemInstances.systemInstances[instanceName] as? JoomlaModel
                if (joomlamodel!.getVersions(forceUpdate: false)) {
                    if (joomlamodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), joomlamodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                let joomlaHeadModel = HeadInstances.headInstances["Joomla"].self as! JoomlaHeadModel
                if (!(joomlaHeadModel.saveConfigfile(filename: Constants.joomlaHead))) {
                    print("Error saving Joomla headversion plist File.")
                }
                joomlamodel!.updateDate()
                if (!(joomlamodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            } else if((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                let owncloudmodel = SystemInstances.systemInstances[instanceName] as? OwncloudModel
                if (owncloudmodel!.getVersions(forceUpdate: false)) {
                    if (owncloudmodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), owncloudmodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                let owncloudHeadModel = HeadInstances.headInstances["Owncloud"].self as! OwncloudHeadModel
                if (!(owncloudHeadModel.saveConfigfile(filename: Constants.owncloudHead))) {
                    print("Error saving Owncloud headversion plist File.")
                }
                owncloudmodel!.updateDate()
                if (!(owncloudmodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            } else if((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                let piwikmodel = SystemInstances.systemInstances[instanceName] as? PiwikModel
                if (piwikmodel!.getVersions(forceUpdate: false)) {
                    if (piwikmodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), piwikmodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                let piwikHeadModel = HeadInstances.headInstances["Piwik"].self as! PiwikHeadModel
                if (!(piwikHeadModel.saveConfigfile(filename: Constants.piwikHead))) {
                    print("Error saving Piwik headversion plist File.")
                }
                piwikmodel!.updateDate()
                if (!(piwikmodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            } else if((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                let wordpressmodel = SystemInstances.systemInstances[instanceName] as? WordpressModel
                if (wordpressmodel!.getVersions(forceUpdate: false)) {
                    if (wordpressmodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), wordpressmodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                let wordpressHeadModel = HeadInstances.headInstances["Wordpress"].self as! WordpressHeadModel
                if (!(wordpressHeadModel.saveConfigfile(filename: Constants.wordpressHead))) {
                    print("Error saving Wordpress headversion plist File.")
                }
                wordpressmodel!.updateDate()
                if (!(wordpressmodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            }
            completion(returnValue)
        }
    }

}
