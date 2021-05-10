//
//  NextcloudViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 19.03.21.
//  Copyright © 2021 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class NextcloudViewController: GenericViewController {
    
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
        let nextcloudinstance = NextcloudModel(creationDate: "", currentVersion: "", hosturl: urlField.stringValue, headVersion: "", lastRefresh: "", name: instanceName.stringValue, type: "Nextcloud", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = nextcloudinstance.saveConfigfile()
        self.dismiss(self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableContentsAdd"), object: nil)
    }
    
}
