//
//  OwncloudViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class OwncloudViewController: NSViewController {

    @IBOutlet weak var cancelButton: NSLayoutConstraint!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var instanceName: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            return
        }
        let owncloudinstance = OwncloudModel(creationDate: "", currentVersion: "", hosturl: urlField.stringValue, headVersion: "", lastRefresh: "", name: instanceName.stringValue, type: "Owncloud", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = owncloudinstance.saveConfigfile()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        self.dismiss(self)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!(self.urlField.stringValue.hasSuffix("/"))) {
            self.errorMessage.stringValue = NSLocalizedString("urlEnding", comment: "")
            self.errorMessage.isHidden = false
            error = true
        }
        if(!(self.urlField.stringValue.hasPrefix("http"))) {
            self.errorMessage.stringValue = NSLocalizedString("protocolMissing", comment: "")
            self.errorMessage.isHidden = false
            error = true
        }
        return error
    }
}
