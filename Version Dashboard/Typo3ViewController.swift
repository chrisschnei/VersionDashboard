//
//  Typo3ViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 09.04.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class Typo3ViewController: NSViewController {

    @IBOutlet weak var hostURLField: NSTextField!
    @IBOutlet weak var instanceNameField: NSTextField!
    @IBOutlet weak var errorField: NSTextField!
    
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
        if(SystemInstancesModel().checkInstanceNameAlreadyPresent(self.instanceNameField.stringValue)) {
            return
        }
        let typo3instance = Typo3Model(creationDate: "", currentVersion: "", hosturl: self.hostURLField.stringValue, lastRefresh: "", name: self.instanceNameField.stringValue, type: "Typo3", headVersion: "", updateAvailable: 0, phpVersion: "", serverType: "")
        typo3instance.saveConfigfile()
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!(self.hostURLField.stringValue.hasSuffix("/"))) {
            self.instanceNameField.stringValue = NSLocalizedString("urlEnding", comment: "")
            self.instanceNameField.hidden = false
            error = true
        }
        if(!(self.hostURLField.stringValue.hasPrefix("http"))) {
            self.instanceNameField.stringValue = NSLocalizedString("protocolMissing", comment: "")
            self.instanceNameField.hidden = false
            error = true
        }
        return error
    }
}
