//
//  PiwikController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class PiwikController: NSViewController {

    @IBOutlet weak var hostUrl: NSTextField!
    @IBOutlet weak var tokenField: NSTextField!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var saveButton: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func saveAction(sender: AnyObject) {
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissController(self)
    }
    
}
