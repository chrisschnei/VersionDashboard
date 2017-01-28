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
        NotificationCenter.default.addObserver(self, selector: #selector(AddSystemViewController.cancelClicked(_:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        // Do view setup here.
    }
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    func closeView() {
        self.dismiss(self)
    }
    
    
}
