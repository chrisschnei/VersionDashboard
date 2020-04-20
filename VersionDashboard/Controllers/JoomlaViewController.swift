//
//  JoomlaViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class JoomlaViewController: GenericViewController {

    @IBOutlet weak var hostUrl: NSTextField!
    @IBOutlet weak var instanceName: NSTextFieldCell!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var cancelButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        if (self.checkURLTextfields(hostUrlTextfield: self.hostUrl, infoTitle: self.errorMessage)) {
            return
        }
        if (SystemInstancesModel.checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            self.errorMessage.isHidden = false
            self.errorMessage.stringValue = NSLocalizedString("instanceDuplicate", comment: "")
            return
        }
        let joomlainstance = JoomlaModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, headVersion: "", lastRefresh: "", name: instanceName.stringValue, type: "Joomla", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = joomlainstance.saveConfigfile()
        self.dismiss(self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableContents"), object: nil)
    }
    
}
