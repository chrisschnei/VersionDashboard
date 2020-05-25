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
    
    var filteredInstances = Dictionary<String, AnyObject>()
    
    func takeMeToMyInstance(_ systemInstanceName : String) -> Bool {
        let instance = SystemInstances.systemInstances[systemInstanceName]
        var url = ""
        if ((instance as? JoomlaModel) != nil) {
            url = (instance as! JoomlaModel).hosturl + Constants.joomlaBackendURL
        } else if ((instance as? WordpressModel) != nil) {
            url = (instance as! WordpressModel).hosturl + Constants.wordpressBackendURL
        } else if ((instance as? PiwikModel) != nil) {
            url = (instance as! PiwikModel).hosturl
        } else if ((instance as? OwncloudModel) != nil) {
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
        NotificationCenter.default.post(name: Notification.Name(rawValue: "viewWillAppear"), object: nil)
        return true
    }
    
    func updateSingleInstance(instanceName: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            var returnValue = true
            if ((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
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
            } else if ((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
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
            } else if ((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
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
            } else if ((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
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
    
    func checkURLTextfields(hostUrlTextfield: UITextField!, infoTitle: UILabel!) -> Bool {
        var error = false
        if (!((hostUrlTextfield.text?.hasSuffix("/"))!)) {
            infoTitle.text = NSLocalizedString("urlEnding", comment: "")
            infoTitle.isHidden = false
            error = true
        }
        if (!((hostUrlTextfield.text?.hasPrefix("http"))!)) {
            infoTitle.text = NSLocalizedString("protocolMissing", comment: "")
            infoTitle.isHidden = false
            error = true
        }
        return error
    }
    
    func createCell(instance: AnyObject) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        var name = ""
        let ratio = 30
        if ((instance as? JoomlaModel) != nil) {
            let resizedImage = UIImage(named: "joomla_dots.png")?.resized(to: CGSize(width: ratio, height: ratio))
            cell.imageView?.image = resizedImage
            name = (instance as! JoomlaModel).name
        } else if ((instance as? WordpressModel) != nil) {
            let resizedImage = UIImage(named: "wordpress_dots.png")?.resized(to: CGSize(width: ratio, height: ratio))
            cell.imageView?.image = resizedImage
            name = (instance as! WordpressModel).name
        } else if ((instance as? PiwikModel) != nil) {
            let resizedImage = UIImage(named: "piwik_dots.png")?.resized(to: CGSize(width: ratio, height: ratio))
            cell.imageView?.image = resizedImage
            name = (instance as! PiwikModel).name
        } else {
            let resizedImage = UIImage(named: "owncloud_dots.png")?.resized(to: CGSize(width: ratio, height: ratio))
            cell.imageView?.image = resizedImage
            name = (instance as! OwncloudModel).name
        }
        cell.textLabel?.text = name
        
        return cell
    }
    
    func createTrailingSwipeActions(systemInstanceName: String) -> [UIContextualAction] {
        let path = (Constants.plistFilesPath + systemInstanceName) + ".plist"
        let deleteAction = UIContextualAction(style: .normal, title: nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if (self.deleteInstance(path, systemInstanceName)) {
                success(true)
            } else {
                success(false)
            }
        })
        // iOS >= 13 use UIimage(init(systemName: UIBarButtonItem.SystemItem.trash))
        deleteAction.image = UIImage(named: "trash")
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
    }
    
    func createLeadingSwipeActions(systemInstanceName: String) -> [UIContextualAction] {
        let takeMeToMyInstanceAction = UIContextualAction(style: .normal, title: nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if (self.takeMeToMyInstance(systemInstanceName)) {
                success(true)
                } else {
                success(false)
            }
        })
        // iOS >= 13 use UIimage(init(systemName: UIBarButtonItem.SystemItem.home))
        takeMeToMyInstanceAction.image = UIImage(named: "home")
        // yellow
        takeMeToMyInstanceAction.backgroundColor = UIColor(red: 255/255, green: 206/255, blue: 93/255, alpha: 1.00)
    
        let refreshAction = UIContextualAction(style: .normal, title: nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let nameDataDict:[String: String] = ["systemInstanceName": systemInstanceName]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshInstance"), object: nil, userInfo: nameDataDict)
            success(true)
        })
        // iOS >= 13 use UIimage(init(systemName: UIBarButtonItem.SystemItem.refresh))
        refreshAction.image = UIImage(named: "refresh")
        // green
        refreshAction.backgroundColor = UIColor(red: 0/255, green: 205/255, blue: 90/255, alpha: 1.00)
        
        return [refreshAction, takeMeToMyInstanceAction]
    }

}
