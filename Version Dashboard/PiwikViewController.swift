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
    @IBOutlet weak var saveButton: NSLayoutConstraint!
    @IBOutlet weak var instanceName: NSTextField!
    
    @IBOutlet weak var errorMessage: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        let piwikinstance = PiwikModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, apiToken : tokenField.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Piwik", headVersion: "", updateAvailable: 0)
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
            self.errorMessage.stringValue = "URL must end with a /. "
            self.errorMessage.hidden = false
            error = true
        }
        if(!(self.hostUrl.stringValue.hasPrefix("http"))) {
            self.errorMessage.stringValue = "No protocol specified."
            self.errorMessage.hidden = false
            error = true
        }
        return error
    }
    
}
