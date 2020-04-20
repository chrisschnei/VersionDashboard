//
//  OwncloudViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class OwncloudViewController: GenericViewController {

    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var instanceName: NSTextField!
    @IBOutlet weak var errorMessage: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        if (checkURLTextfields(hostUrlTextfield: self.urlField, infoTitle: self.errorMessage)) {
            return
        }
        if (SystemInstancesModel.checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            return
        }
        let owncloudinstance = OwncloudModel(creationDate: "", currentVersion: "", hosturl: urlField.stringValue, headVersion: "", lastRefresh: "", name: instanceName.stringValue, type: "Owncloud", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = owncloudinstance.saveConfigfile()
        self.dismiss(self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableContents"), object: nil)
    }
    
}
