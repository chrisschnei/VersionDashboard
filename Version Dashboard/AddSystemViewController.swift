//
//  AddSystemViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class AddSystemViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cancelClicked:", name: "load", object: nil)
        // Do view setup here.
    }
    
    @IBAction func cancelClicked(sender: AnyObject) {
        self.dismissController(self)
    }
    
    func closeView() {
        self.dismissController(self)
    }
    
    
}
