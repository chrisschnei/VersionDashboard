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
    @IBOutlet weak var errorMessage: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissController(self)
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        let joomlainstance = JoomlaModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Joomla", headVersion: "")
        joomlainstance.saveConfigfile()
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!(self.hostUrl.stringValue.hasSuffix("/"))) {
            self.errorMessage.stringValue = "URL must end with a /. "
            self.errorMessage.hidden = false
            error = true
        }
        if(!(self.hostUrl.stringValue.hasPrefix("http"))) {
            self.errorMessage.stringValue = "No protocol specified."
            self.errorMessage.hidden = false
            error = true
        }
        return error
    }
}
