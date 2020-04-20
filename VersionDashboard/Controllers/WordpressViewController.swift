//
//  WordpressViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class WordpressViewController: GenericViewController {

    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var instanceName: NSTextField!
    @IBOutlet weak var hostUrl: NSTextField!
    @IBOutlet weak var cancelButton: NSButton!
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
        let wordpressinstance = WordpressModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, headVersion: "", lastRefresh: "", name: instanceName.stringValue, type: "Wordpress", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = wordpressinstance.saveConfigfile()
        self.dismiss(self)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableContents"), object: nil)
    }

}
