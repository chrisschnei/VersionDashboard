//
//  PreferencesWindowController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.03.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class PreferencesWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        if let viewController = contentViewController as? PreferencesViewController {
            return viewController.makeTouchBar()
        }
        return nil
    }

}
