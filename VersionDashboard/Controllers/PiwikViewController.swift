//
//  PiwikController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class PiwikViewController: GenericViewController {

    @IBOutlet weak var hostUrl: NSTextField!
    @IBOutlet weak var tokenField: NSTextField!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var instanceName: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        if (self.checkURLTextfields(hostUrlTextfield: self.hostUrl, infoTitle: self.errorMessage)) {
            return
        }
        if (SystemInstancesModel.checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            return
        }
        let piwikinstance = PiwikModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, apiToken : tokenField.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Piwik", headVersion: "", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = piwikinstance.saveConfigfile()
        self.dismiss(self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableContents"), object: nil)
    }
    
}
