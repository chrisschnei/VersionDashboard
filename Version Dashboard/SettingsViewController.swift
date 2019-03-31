//
//  SettingsViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class SettingsViewController: NSViewController {

    @IBOutlet weak var settingsLabel: NSTextField!
    @IBOutlet weak var hostTextbox: NSTextField!
    @IBOutlet weak var lastcheckLabel: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var apiToken: NSTextField!
    @IBOutlet weak var apiTokenLabel: NSTextField!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var errorLabel: NSTextField!
    var instanceName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInstanceDetails()
    }
    
    func loadInstanceDetails() {
        let instance = SystemInstances.systemInstances[instanceName]
        if((instance as? JoomlaModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! JoomlaModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
        } else if((instance as? OwncloudModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! OwncloudModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
        } else if((instance as? PiwikModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! PiwikModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
            self.apiToken.isHidden = false
            self.apiTokenLabel.isHidden = false
            
            self.apiToken.stringValue = instanceObject.apiToken
        } else if((instance as? WordpressModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! WordpressModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
        }
    }
    
    func updateConfigfile() -> Bool {
        let instance = SystemInstances.systemInstances[instanceName]
        if((instance as? JoomlaModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! JoomlaModel
            instanceObject.hosturl = self.hostTextbox.stringValue
            instanceObject.name = self.settingsLabel.stringValue
            
            if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.settingsLabel.stringValue)) {
                return instanceObject.saveConfigfile()
            } else {
                instanceObject.renamePlistFile(instanceName)
                return instanceObject.saveConfigfile()
            }
        } else if((instance as? OwncloudModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! OwncloudModel
            instanceObject.hosturl = self.hostTextbox.stringValue
            instanceObject.name = self.settingsLabel.stringValue
            
            if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.settingsLabel.stringValue)) {
                return instanceObject.saveConfigfile()
            } else {
                instanceObject.renamePlistFile(instanceName)
                return instanceObject.saveConfigfile()
            }
        } else if((instance as? PiwikModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! PiwikModel
            instanceObject.hosturl = self.hostTextbox.stringValue
            instanceObject.name = self.settingsLabel.stringValue
            instanceObject.apiToken = self.apiToken.stringValue
            
            if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.settingsLabel.stringValue)) {
                return instanceObject.saveConfigfile()
            } else {
                instanceObject.renamePlistFile(instanceName)
                return instanceObject.saveConfigfile()
            }
        } else if((instance as? WordpressModel) != nil) {
            let instanceObject = SystemInstances.systemInstances[instanceName] as! WordpressModel
            instanceObject.hosturl = self.hostTextbox.stringValue
            instanceObject.name = self.settingsLabel.stringValue
            
            if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.settingsLabel.stringValue)) {
                return instanceObject.saveConfigfile()
            } else {
                instanceObject.renamePlistFile(instanceName)
                return instanceObject.saveConfigfile()
            }
        }
        return false
    }
    
    @IBAction func cancelButton(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
        if(!self.updateConfigfile()) {
            return
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        self.dismiss(self)
    }
}
