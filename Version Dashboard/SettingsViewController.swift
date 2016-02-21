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
    @IBOutlet weak var cancelButton: NSButton!
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
        }
    }
    
    func updateConfigfile() -> Bool {
        let instance = systemInstances[instanceName]
        if((instance as? JoomlaModel) != nil) {
            let instanceObject = systemInstances[instanceName] as! JoomlaModel
            let path = appurl.stringByAppendingString(self.instanceName).stringByAppendingString(".plist")
            let dict: NSMutableDictionary = NSMutableDictionary()
            
            dict.setObject(self.hostTextbox.stringValue, forKey: "hosturl")
            dict.setObject(instanceObject.name, forKey: "name")
            dict.setObject(instanceObject.currentVersion, forKey: "currentVersion")
            dict.setObject(instanceObject.lastRefresh, forKey: "lastRefresh")
            dict.setObject(instanceObject.headVersion, forKey: "headVersion")
            dict.setObject(instanceObject.creationDate, forKey: "creationDate")
            dict.setObject("Joomla", forKey: "type")
            
            return dict.writeToFile(path, atomically: true)
        } else {
            return false
        }
    }

    
    @IBAction func cancelButton(sender: AnyObject) {
        self.dismissController(self)
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        self.updateConfigfile()
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
}
