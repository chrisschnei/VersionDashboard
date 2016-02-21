//
//  WordpressViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class WordpressViewController: NSViewController {

    @IBOutlet weak var hostUrl: NSTextField!
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
