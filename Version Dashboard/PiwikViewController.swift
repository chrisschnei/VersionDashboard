//
//  PiwikController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class PiwikController: NSViewController {

    @IBOutlet weak var hostUrl: NSTextField!
    @IBOutlet weak var tokenField: NSTextField!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var instanceName: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            return
        }
        let piwikinstance = PiwikModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, apiToken : tokenField.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Piwik", headVersion: "", updateAvailable: 0, phpVersion: "", serverType: "")
        piwikinstance.saveConfigfile()
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissController(self)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!(self.hostUrl.stringValue.hasSuffix("/"))) {
            self.errorMessage.stringValue = NSLocalizedString("urlEnding", comment: "")
            self.errorMessage.hidden = false
            error = true
        }
        if(!(self.hostUrl.stringValue.hasPrefix("http"))) {
            self.errorMessage.stringValue = NSLocalizedString("protocolMissing", comment: "")
            self.errorMessage.hidden = false
            error = true
        }
        return error
    }
    
}
