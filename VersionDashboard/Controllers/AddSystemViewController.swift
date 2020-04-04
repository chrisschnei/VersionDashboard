//
//  AddSystemViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class AddSystemViewController: NSViewController {
    
    var addPiwikItem: NSCustomTouchBarItem!
    var addOwncloudItem: NSCustomTouchBarItem!
    var addJoomlaItem: NSCustomTouchBarItem!
    var addWordpressItem: NSCustomTouchBarItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(AddSystemViewController.cancelClicked(_:)), name: NSNotification.Name(rawValue: "reloadTableContents"), object: nil)
    }
    
    @IBAction func cancelClicked(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    @IBAction func loadPiwikController(_ sender: AnyObject) {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateController(withIdentifier: "PiwikController") as! PiwikViewController
        presentAsSheet(nextViewController)
    }
    
    @IBAction func loadOwncloudController(_ sender: AnyObject) {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateController(withIdentifier: "OwncloudViewController") as! OwncloudViewController
        presentAsSheet(nextViewController)
    }
    
    @IBAction func loadWordpressController(_ sender: AnyObject) {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateController(withIdentifier: "WordpressViewController") as! WordpressViewController
        presentAsSheet(nextViewController)
    }
    
    @IBAction func loadJoomlaController(_ sender: AnyObject) {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateController(withIdentifier: "JoomlaViewController") as! JoomlaViewController
        presentAsSheet(nextViewController)
    }
    
}

/**
 NSTouchBarDelegate extension for view controller.
 */
extension AddSystemViewController: NSTouchBarDelegate {
    /**
     Generates a custom TouchBar.
     
     - Returns: Custom NSTouchBar.
     */
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarAddInstance
        touchBar.defaultItemIdentifiers = [.owncloudInstanceTouchbar, .piwikInstanceTouchbar, .joomlaInstanceTouchbar, .wordpressInstanceTouchbar]
        touchBar.customizationAllowedItemIdentifiers = [.owncloudInstanceTouchbar, .piwikInstanceTouchbar, .joomlaInstanceTouchbar, .wordpressInstanceTouchbar]
        return touchBar
    }
    
    /**
     Creates AddSystemViewController specific TouchBar buttons.
     
     - Parameters:
     - touchBar: TouchBar to be added to
     - identifier: NSTouchBarItem identifier.
     - Returns: NSTouchBarItem to be added to TouchBar, nil in case of failure.
     */
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItem.Identifier.owncloudInstanceTouchbar:
            self.addOwncloudItem = NSCustomTouchBarItem(identifier: identifier)
            let owncloudButton = NSButton(image: NSImage(named: "owncloud.png")!, target: self, action: #selector(self.loadOwncloudController))
            self.addOwncloudItem.view = owncloudButton
            return self.addOwncloudItem
        case NSTouchBarItem.Identifier.wordpressInstanceTouchbar:
            self.addWordpressItem = NSCustomTouchBarItem(identifier: identifier)
            let wordpressButton = NSButton(image: NSImage(named: "wordpress.png")!, target: self, action: #selector(self.loadWordpressController))
            self.addWordpressItem.view = wordpressButton
            return self.addWordpressItem
        case NSTouchBarItem.Identifier.joomlaInstanceTouchbar:
            self.addJoomlaItem = NSCustomTouchBarItem(identifier: identifier)
            let joomlaButton = NSButton(image: NSImage(named: "joomla.png")!, target: self, action: #selector(self.loadJoomlaController))
            self.addJoomlaItem.view = joomlaButton
            return self.addJoomlaItem
        case NSTouchBarItem.Identifier.piwikInstanceTouchbar:
            self.addPiwikItem = NSCustomTouchBarItem(identifier: identifier)
            let piwikButton = NSButton(image: NSImage(named: "matamo.png")!, target: self, action: #selector(self.loadPiwikController))
            self.addPiwikItem.view = piwikButton
            return self.addPiwikItem
        default:
            return nil
        }
    }
}

