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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissController(self)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let joomlainstance = JoomlaModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Joomla", headVersion: "")
        joomlainstance.saveConfigfile()
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
}
