//
//  SettingsViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

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
        // Do view setup here.
        self.loadInstanceDetails()
    }
    
    func loadInstanceDetails() {
        let instance = systemInstances[instanceName]
        if((instance as? JoomlaModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! JoomlaModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
        } else if((instance as? OwncloudModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! OwncloudModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
        } else if((instance as? PiwikModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! PiwikModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
            self.apiToken.hidden = false
            self.apiTokenLabel.hidden = false
            
            self.apiToken.stringValue = instanceObject.apiToken
        } else if((instance as? WordpressModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! WordpressModel
            self.settingsLabel.stringValue = instanceName
            self.lastcheckLabel.stringValue = instanceObject.lastRefresh
            self.hostTextbox.stringValue = instanceObject.hosturl
        }
    }
    
    func updateConfigfile() -> Bool {
        let instance = systemInstances[instanceName]
        if((instance as? JoomlaModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! JoomlaModel
            instanceObject.hosturl = self.hostTextbox.stringValue
            instanceObject.name = self.settingsLabel.stringValue
            
            if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.settingsLabel.stringValue)) {
                return instanceObject.saveConfigfile()
            } else {
                instanceObject.renamePlistFile(instanceName)
                return instanceObject.saveConfigfile()
            }
        } else if((instance as? OwncloudModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! OwncloudModel
            instanceObject.hosturl = self.hostTextbox.stringValue
            instanceObject.name = self.settingsLabel.stringValue
            
            if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.settingsLabel.stringValue)) {
                return instanceObject.saveConfigfile()
            } else {
                instanceObject.renamePlistFile(instanceName)
                return instanceObject.saveConfigfile()
            }
        } else if((instance as? PiwikModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! PiwikModel
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
            let instanceObject = systemInstances[instanceName] as! WordpressModel
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
    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissController(self)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        if(!self.updateConfigfile()) {
            return
        }
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
}
