//
//  GenericViewController.swift
//  VersionDashboard
//
//  Created by Christian Schneider on 19.04.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class GenericViewController : NSViewController {
    
    func checkURLTextfields(hostUrlTextfield: NSTextField!, infoTitle: NSTextField!) -> Bool {
        var error = false
        if (!((hostUrlTextfield.stringValue.hasSuffix("/")))) {
            infoTitle.stringValue = NSLocalizedString("urlEnding", comment: "")
            infoTitle.isHidden = false
            error = true
        }
        if (!((hostUrlTextfield.stringValue.hasPrefix("http")))) {
            infoTitle.stringValue = NSLocalizedString("protocolMissing", comment: "")
            infoTitle.isHidden = false
            error = true
        }
        return error
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    func copyToClipboard() -> Bool {
        let owncloudhead = HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel
        if (owncloudhead.downloadurl == "") {
            return false
        }
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        return pasteboard.setString(owncloudhead.downloadurl, forType: NSPasteboard.PasteboardType.string)
    }
    
    func instantiateDetailedViewController() -> DetailedViewController {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        return storyBoard.instantiateController(withIdentifier: "DetailedViewController") as! DetailedViewController
    }
    
    func instantiateOutdatedViewController() -> OutdatedViewController {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        return storyBoard.instantiateController(withIdentifier: "OutdatedViewController") as! OutdatedViewController
    }
    
    func instantiateSummaryViewController() -> SummaryViewController {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        return storyBoard.instantiateController(withIdentifier: "SummaryViewController") as! SummaryViewController
    }
    
    func instantiateOwncloudViewController() -> OwncloudViewController {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        return storyBoard.instantiateController(withIdentifier: "OwncloudViewController") as! OwncloudViewController
    }
    
    func instantiateJoomlaViewController() -> JoomlaViewController {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        return storyBoard.instantiateController(withIdentifier: "JoomlaViewController") as! JoomlaViewController
    }
    
    func instantiateWordpressViewController() -> WordpressViewController {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        return storyBoard.instantiateController(withIdentifier: "WordpressViewController") as! WordpressViewController
    }
    
    func instantiatePiwikViewController() -> PiwikViewController {
        let storyBoard : NSStoryboard = NSStoryboard(name: "Main", bundle:nil)
        return storyBoard.instantiateController(withIdentifier: "PiwikController") as! PiwikViewController
    }
    
    func createTableCell(tableView: NSTableView, filteredInstancesArray: Array<String>, row: Int) -> NSTableCellView {
        tableView.rowHeight = 30.0
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "InstanceName"), owner: self) as! NSTableCellView
        let name = filteredInstancesArray[row]
        if ((SystemInstances.systemInstances[name] as? OwncloudModel) != nil) {
            cellView.imageView!.image = NSImage(named: NSImage.Name("owncloud_dots.png"))!
        } else if ((SystemInstances.systemInstances[name] as? PiwikModel) != nil) {
            cellView.imageView!.image = NSImage(named: NSImage.Name("piwik_dots.png"))!
        } else if ((SystemInstances.systemInstances[name] as? WordpressModel) != nil) {
            cellView.imageView!.image = NSImage(named: NSImage.Name("wordpress_dots.png"))!
        } else if ((SystemInstances.systemInstances[name] as? JoomlaModel) != nil) {
            cellView.imageView!.image = NSImage(named: NSImage.Name("joomla_dots.png"))!
        }
        cellView.textField?.stringValue = name
        
        return cellView
    }
    
    func openInstanceWebsite(selectedRow: Int, filteredInstancesArray: Array<String>, filtertext: String) -> Bool {
        if (selectedRow != -1) {
            var key : String
            if (!filtertext.isEmpty) {
                key = filteredInstancesArray[selectedRow]
            } else {
                key = Array(SystemInstances.systemInstances.keys)[selectedRow]
            }
            let instance = SystemInstances.systemInstances[key]
            var url = ""
            if ((instance as? JoomlaModel) != nil) {
                url = (instance as! JoomlaModel).hosturl + Constants.joomlaBackendURL
            } else if ((instance as? WordpressModel) != nil) {
                url = (instance as! WordpressModel).hosturl + Constants.wordpressBackendURL
            } else if ((instance as? PiwikModel) != nil) {
                url = (instance as! PiwikModel).hosturl
            } else if ((instance as? OwncloudModel) != nil) {
                url = (instance as! OwncloudModel).hosturl
            }
            return NSWorkspace.shared.open(URL(string: url)!)
        }
        return false
    }
    
    /**
     Replace existing view controller by detailed view controller.
     */
    @IBAction func loadDetailedViewController(_: Any) {
        let controller: DetailedViewController?
        controller = instantiateDetailedViewController()
        if (controller == nil) {
            print("Instantiating detailed view controller did not work.")
            return
        }
        self.view.window?.contentViewController = controller
    }
    
    /**
     Replace existing view controller by summary view controller.
     */
    @IBAction func loadSummaryViewController(_: Any) {
        let controller: SummaryViewController?
        controller = instantiateSummaryViewController()
        if (controller == nil) {
            print("Instantiating summary view controller did not work.")
            return
        }
        self.view.window?.contentViewController = controller
    }
    
    /**
     Replace existing view controller by outdated view controller.
     */
    @IBAction func loadOutdatedViewController(_: Any) {
        let controller: OutdatedViewController?
        controller = instantiateOutdatedViewController()
        if (controller == nil) {
            print("Instantiating outdated view controller did not work.")
            return
        }
        self.view.window?.contentViewController = controller
    }
    
    /**
     Load modal preferences window dialog.
     */
    @IBAction func loadPreferencesWindow(_: Any) {
        let myWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "PreferencesViewController") as? PreferencesViewController
        if (myWindowController == nil) {
            print("Instantiating preferences view controller did not work.")
            return
        }
        presentAsModalWindow(myWindowController!)
    }

}
