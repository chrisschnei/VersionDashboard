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
    @IBOutlet weak var tokenField: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissController(self)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
    }
}
