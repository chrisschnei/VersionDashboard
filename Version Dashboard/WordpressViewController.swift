//
//  WordpressViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class WordpressViewController: NSViewController {

    @IBOutlet weak var errorMessage: NSTextField!
    @IBOutlet weak var instanceName: NSTextField!
    @IBOutlet weak var hostUrl: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.instanceName.stringValue)) {
            return
        }
        let wordpressinstance = WordpressModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Wordpress", headVersion: "", updateAvailable: 0, phpVersion: "", serverType: "")
        _ = wordpressinstance.saveConfigfile()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "load"), object: nil)
        self.dismiss(self)
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
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
