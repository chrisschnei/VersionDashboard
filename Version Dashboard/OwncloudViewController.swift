//
//  OwncloudViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class OwncloudViewController: NSViewController {

    @IBOutlet weak var cancelButton: NSLayoutConstraint!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var instanceName: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissController(self)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            return
        }
        let owncloudinstance = OwncloudModel(creationDate: "", currentVersion: "", hosturl: urlField.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Owncloud", headVersion: "", updateAvailable: 0, phpVersion: "", serverType: "")
        owncloudinstance.saveConfigfile()
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!(self.urlField.stringValue.hasSuffix("/"))) {
            self.errorMessage.stringValue = NSLocalizedString("urlEnding", comment: "")
            self.errorMessage.hidden = false
            error = true
        }
        if(!(self.urlField.stringValue.hasPrefix("http"))) {
            self.errorMessage.stringValue = NSLocalizedString("protocolMissing", comment: "")
            self.errorMessage.hidden = false
            error = true
        }
        return error
    }
}
