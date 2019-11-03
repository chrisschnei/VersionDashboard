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
        NotificationCenter.default.addObserver(self, selector: #selector(AddSystemViewController.cancelClicked(_:)), name: NSNotification.Name(rawValue: "reloadTableContents"), object: nil)
    }
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        self.dismiss(self)
    }    
    
}
