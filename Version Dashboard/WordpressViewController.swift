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
    
    @IBAction func saveAction(sender: AnyObject) {
        if(self.checkURLTextfields()) {
            return
        }
        if(self.checkInstanceNameAlreadyPresent()) {
            return
        }
        let wordpressinstance = WordpressModel(creationDate: "", currentVersion: "", hosturl: hostUrl.stringValue, lastRefresh: "", name: instanceName.stringValue, type: "Wordpress", headVersion: "", updateAvailable: 0, phpVersion: "", serverType: "")
        wordpressinstance.saveConfigfile()
        NSNotificationCenter.defaultCenter().postNotificationName("load", object: nil)
        self.dismissController(self)
    }
    
    func checkInstanceNameAlreadyPresent() -> Bool {
        var alreadyPresent = false
        let fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(appurl.stringByAppendingString(self.instanceName.stringValue).stringByAppendingString(".plist")))
        {
            alreadyPresent = true
            self.errorMessage.hidden = false
            self.errorMessage.stringValue = NSLocalizedString("instanceDuplicate", comment: "")
        }
        return alreadyPresent
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissController(self)
    }
    
    func checkURLTextfields() -> Bool {
        var error = false
        if(!(self.hostUrl.stringValue.hasSuffix("/"))) {
            self.errorMessage.stringValue = NSLocalizedString("urlEnding", comment: "")
            self.errorMessage.hidden = false
            error = true
        }
        if(!(self.hostUrl.stringValue.hasPrefix("http"))) {
            self.errorMessage.stringValue = NSLocalizedString("protocolMissing", comment: "")
            self.errorMessage.hidden = false
            error = true
        }
        return error
    }
}
