//
//  MainWindow.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class MainWindow: NSWindowController {

    @IBOutlet weak var mainwindows: NSWindow!
    @IBOutlet weak var summaryview: NSToolbarItem!
    @IBOutlet weak var detailedview: NSToolbarItem!
    @IBOutlet weak var tabbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        self.mainwindows.titleVisibility = NSWindowTitleVisibility.Hidden;
//        self.mainwindows.titlebarAppearsTransparent = True;
        self.mainwindows.styleMask |= NSFullSizeContentViewWindowMask;
    }

}
