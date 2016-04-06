//
//  MainWindow.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class MainWindow: NSWindowController {

    @IBOutlet weak var mainwindow: NSWindow!
    @IBOutlet weak var summaryview: NSToolbarItem!
    @IBOutlet weak var detailedview: NSToolbarItem!
    @IBOutlet weak var outdatedItem: NSToolbarItem!
    @IBOutlet weak var tabbar: NSToolbar!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.mainwindow.titleVisibility = NSWindowTitleVisibility.Visible
        self.mainwindow.styleMask |= NSFullSizeContentViewWindowMask
        //Reopen windows when closed
        let appDelegate = NSApp.delegate as! AppDelegate
        appDelegate.mainWindowController = self
    }

    @IBAction func detailedViewClicked(sender: AnyObject) {
        let viewController = storyboard?.instantiateControllerWithIdentifier("detailedviewcontroller") as! NSViewController
        self.mainwindow?.contentViewController = viewController
    }
    
    @IBAction func summaryViewClicked(sender: AnyObject) {
        let viewController = storyboard?.instantiateControllerWithIdentifier("summaryviewcontroller") as! NSViewController
        self.window?.contentViewController = viewController
    }
    
    @IBAction func outdatedViewClicked(sender: AnyObject) {
        let viewController = storyboard?.instantiateControllerWithIdentifier("outdatedviewcontroller") as! NSViewController
        self.window?.contentViewController = viewController
    }
}
