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
        self.mainwindow.titleVisibility = NSWindow.TitleVisibility.visible
        //Reopen window when closed
        let appDelegate = NSApp.delegate as! AppDelegate
        appDelegate.mainWindowController = self
    }
    
    @IBAction func detailedViewClicked(_ sender: AnyObject) {
        let viewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DetailedViewController")) as! NSViewController
        self.mainwindow?.contentViewController = viewController
    }
    
    @IBAction func summaryViewClicked(_ sender: AnyObject) {
        let viewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("SummaryViewController")) as! NSViewController
        self.window?.contentViewController = viewController
    }
    
    @IBAction func outdatedViewClicked(_ sender: AnyObject) {
        let viewController = storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("OutdatedViewController")) as! NSViewController
        self.window?.contentViewController = viewController
    }
    
    override func makeTouchBar() -> NSTouchBar? {
        if let viewController = contentViewController as? SummaryViewController {
            return viewController.makeTouchBar()
        }
        if let viewController = contentViewController as? DetailedViewController {
            return viewController.makeTouchBar()
        }
        if let viewController = contentViewController as? OutdatedViewController {
            return viewController.makeTouchBar()
        }
        return nil
    }
}
