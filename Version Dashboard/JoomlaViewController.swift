//
//  JoomlaViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class JoomlaViewController: NSViewController {

    @IBOutlet weak var hostUrl: NSTextField!
    @IBOutlet weak var instanceName: NSTextFieldCell!
    @IBOutlet weak var errorMessage: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            self.errorMessage.isHidden = false
            self.errorMessage.stringValue = NSLocalizedString("instanceDuplicate", comment: "")
            return
        }
        let joomlainstance = JoomlaModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Joomla", headVersion: "", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = joomlainstance.saveConfigfile()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        self.dismiss(self)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!(self.hostUrl.stringValue.hasSuffix("/"))) {
            self.errorMessage.stringValue = NSLocalizedString("urlEnding", comment: "")
            self.errorMessage.isHidden = false
            error = true
        }
        if(!(self.hostUrl.stringValue.hasPrefix("http"))) {
            self.errorMessage.stringValue = NSLocalizedString("protocolMissing", comment: "")
            self.errorMessage.isHidden = false
            error = true
        }
        return error
    }
}
