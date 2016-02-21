//
//  ViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import SystemConfiguration
import Foundation

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var systemLabel: NSTextField!
    @IBOutlet weak var hostLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var lastcheckLabel: NSTextField!
    @IBOutlet weak var deployedversionLabel: NSTextField!
    @IBOutlet weak var latestsversionLabel: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var systemTableView: NSTableView!
    @IBOutlet weak var noInternetConnection: NSTextField!
    @IBOutlet weak var checkActiveSpinner: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTable:", name: "load", object: nil)
        self.loadConfigfiles()
        systemTableView.setDelegate(self)
        systemTableView.setDataSource(self)
        self.addInstancesToTable()
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if (((sender as! NSButton).title) == "Edit") {
            let destination = segue.destinationController as! SettingsViewController
            let instances = Array(systemInstances.keys)
            let instanceNa = instances[self.systemTableView.selectedRow]
            destination.instanceName = instanceNa
        }
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func checkInternetConnection() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
                SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
    }

    func deleteFile(path: String) {
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtPath(path)
        }
        catch let error as NSError {
            print("Error deleting plist file: \(error)")
        }
    }
    
    @IBAction func removeInstance(sender: AnyObject) {
        let instances = Array(systemInstances.keys)
        let filename = instances[self.systemTableView.selectedRow]
        let path = appurl.stringByAppendingString(filename).stringByAppendingString(".plist")
        self.deleteFile(path)
        systemInstances.removeAll()
        self.loadConfigfiles()
        self.addInstancesToTable()
    }
    
    func addInstancesToTable() {
        self.systemTableView.reloadData()
    }
    
    func reloadTable(notification: NSNotification) {
        let selectedRow = self.systemTableView.selectedRow
        self.systemTableView.deselectAll(self)
        systemInstances.removeAll()
        self.loadConfigfiles()
        self.systemTableView.reloadData()
        self.systemTableView.selectRowIndexes((NSIndexSet(index:selectedRow)), byExtendingSelection: false)
    }
    
    @IBAction func refreshInstance(sender: AnyObject) {
        self.checkActiveSpinner.hidden = false
        self.checkActiveSpinner.startAnimation(self)
        if(self.checkInternetConnection()) {
            let selectedRow = systemTableView.selectedRow
            let instanceName = Array(systemInstances.keys)[selectedRow]
            if((systemInstances[instanceName] as? JoomlaModel) != nil) {
                let joomlamodel = systemInstances[instanceName] as? JoomlaModel
                let instanceVersion = joomlamodel!.getInstanceVersion((joomlamodel!.hosturl).stringByAppendingString(joomlapath))
                //Remote Version url
                let headVersion = joomlamodel!.getInstanceVersion(joomlaAPIUrl.stringByAppendingString(joomlapath))
                joomlamodel!.headVersion = headVersion
                joomlamodel!.currentVersion = instanceVersion
                //Check Version
                if(!(headVersion == instanceVersion)) {
                    joomlamodel!.sendNotification("Newer version available", informativeText: "Please update your \(instanceName) instance")
                }
                //Date
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
                joomlamodel!.lastRefresh = dateFormatter.stringFromDate(NSDate())
                if(!(joomlamodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
                self.systemTableView.deselectAll(self)
                self.systemTableView.selectRowIndexes((NSIndexSet(index:selectedRow)), byExtendingSelection: false)
            } else {
                print("Was anderes")
            }            
        } else {
            self.noInternetConnection.hidden = false
            self.refreshButton.enabled = false
        }
        self.checkActiveSpinner.stopAnimation(self)
        self.checkActiveSpinner.hidden = true
    }
    
    func loadConfigfiles() {
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(appurl)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix("plist") {
                let myDict = NSDictionary(contentsOfFile: appurl.stringByAppendingString(element))
                if myDict!["type"] as! String == "Joomla" {
                    systemInstances[myDict!["name"] as! String] = JoomlaModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String)
                } else if myDict!["type"] as! String == "Wordpress" {
                    
                } else if myDict!["type"] as! String == "Owncloud" {
                    systemInstances[myDict!["name"] as! String] = OwncloudM
                } else if myDict!["type"] as! String == "Piwik" {
                    
                }
            }
        }
    }
    
    func updateInstanceDetails(index: Int) {
        if((index) != -1) {
            let key = Array(systemInstances.keys)[index]
            let modelclass = systemInstances[key].self!
            if((modelclass as? JoomlaModel) != nil) {
                let joomlaobject = modelclass as? JoomlaModel
                self.hostLabel.stringValue = joomlaobject!.hosturl
                self.systemLabel.stringValue = joomlaobject!.name
                self.lastcheckLabel.stringValue = joomlaobject!.lastRefresh
                self.latestsversionLabel.stringValue = joomlaobject!.headVersion
                self.deployedversionLabel.stringValue = joomlaobject!.currentVersion
                if(joomlaobject!.headVersion == joomlaobject!.currentVersion) {
                    self.statusLabel.stringValue = "OK"
                } else {
                    self.statusLabel.stringValue = "Update available"
                }
            } else if((modelclass as? WordpressModel) != nil) {
                print("Wordpress instanz")
            }
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cellView = tableView.makeViewWithIdentifier("InstanceName", owner: self) as! NSTableCellView
        let instancesArray = Array(systemInstances.keys)
        cellView.textField?.stringValue = instancesArray[row]
        return cellView
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.updateInstanceDetails(systemTableView.selectedRow)
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return systemInstances.count
    }
    
}

