//
//  OutdatedViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 28.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class OutdatedViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var table: NSScrollView!
    @IBOutlet weak var latestVersion: NSTextField!
    @IBOutlet weak var currentVersion: NSTextField!
    @IBOutlet weak var lastcheck: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var hostName: NSTextField!
    @IBOutlet weak var systemName: NSTextField!
    @IBOutlet weak var latestVersionLabel: NSTextField!
    @IBOutlet weak var currentVersionLabel: NSTextField!
    @IBOutlet weak var lastCheckLabel: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var hostLabel: NSTextField!
    @IBOutlet weak var systemLabel: NSTextField!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var spinner: NSProgressIndicator!
    @IBOutlet weak var errorLabel: NSTextField!
    @IBOutlet weak var phpVersionLabel: NSTextField!
    @IBOutlet weak var phpVersion: NSTextField!
    @IBOutlet weak var webserverLabel: NSLayoutConstraint!
    @IBOutlet weak var webserver: NSTextField!
    
    override func viewDidLoad() {
        outdatedInstances.removeAll()
        tableView.setDelegate(self)
        tableView.setDataSource(self)
    }
    
    func updateInstanceDetails(index: Int) {
        if((index) != -1) {
            let key = outdatedInstances[index]
            let modelclass = systemInstances[key].self!
            if((modelclass as? JoomlaModel) != nil) {
                let joomlaobject = modelclass as? JoomlaModel
                self.hostName.stringValue = joomlaobject!.hosturl
                self.systemName.stringValue = joomlaobject!.name
                self.lastcheck.stringValue = joomlaobject!.lastRefresh
                self.latestVersion.stringValue = joomlaobject!.headVersion
                self.currentVersion.stringValue = joomlaobject!.currentVersion
                self.phpVersion.stringValue = joomlaobject!.phpVersion
                self.webserver.stringValue = joomlaobject!.serverType
                if(self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if(joomlaobject!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if(joomlaobject?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            } else if((modelclass as? OwncloudModel) != nil) {
                let owncloudmodel = modelclass as? OwncloudModel
                self.hostName.stringValue = owncloudmodel!.hosturl
                self.systemName.stringValue = owncloudmodel!.name
                self.lastcheck.stringValue = owncloudmodel!.lastRefresh
                self.latestVersion.stringValue = owncloudmodel!.headVersion
                self.currentVersion.stringValue = owncloudmodel!.currentVersion
                self.phpVersion.stringValue = owncloudmodel!.phpVersion
                self.webserver.stringValue = owncloudmodel!.serverType
                if(self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if(owncloudmodel!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if(owncloudmodel?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            } else if((modelclass as? PiwikModel) != nil) {
                let piwikmodel = modelclass as? PiwikModel
                self.hostName.stringValue = piwikmodel!.hosturl
                self.systemName.stringValue = piwikmodel!.name
                self.lastcheck.stringValue = piwikmodel!.lastRefresh
                self.latestVersion.stringValue = piwikmodel!.headVersion
                self.currentVersion.stringValue = piwikmodel!.currentVersion
                self.phpVersion.stringValue = piwikmodel!.phpVersion
                self.webserver.stringValue = piwikmodel!.serverType
                if(self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if(piwikmodel!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if(piwikmodel?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            } else if((modelclass as? WordpressModel) != nil) {
                let wordpressmodel = modelclass as? WordpressModel
                self.hostName.stringValue = wordpressmodel!.hosturl
                self.systemName.stringValue = wordpressmodel!.name
                self.lastcheck.stringValue = wordpressmodel!.lastRefresh
                self.latestVersion.stringValue = wordpressmodel!.headVersion
                self.currentVersion.stringValue = wordpressmodel!.currentVersion
                self.phpVersion.stringValue = wordpressmodel!.phpVersion
                self.webserver.stringValue = wordpressmodel!.serverType
                if(self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if(wordpressmodel!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if(wordpressmodel?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            }
        }
    }
    
    @IBAction func refreshInstance(sender: AnyObject) {
        self.spinner.hidden = false
        self.spinner.startAnimation(self)
        if(checkInternetConnection()) {
            let selectedRow = tableView.selectedRow
            if(selectedRow != -1) {
                let instanceName = outdatedInstances[selectedRow]
                if((systemInstances[instanceName] as? JoomlaModel) != nil) {
                    let joomlamodel = systemInstances[instanceName] as? JoomlaModel
                    //Remote Version url
                    if(joomlamodel!.getVersions()) {
                        //Check Version
                        self.errorLabel.hidden = true
                        joomlamodel!.checkNotificationRequired()
                    } else {
                        print(NSLocalizedString("errorfetchingVersions", comment: ""))
                        self.errorLabel.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.errorLabel.hidden = false
                    }
                    //Date
                    joomlamodel!.updateDate()
                    if(!(joomlamodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.tableView.deselectAll(self)
                    self.tableView.selectRowIndexes((NSIndexSet(index:selectedRow)), byExtendingSelection: false)
                } else if((systemInstances[instanceName] as? OwncloudModel) != nil) {
                    let owncloudmodel = systemInstances[instanceName] as? OwncloudModel
                    //Remote Version url
                    if(owncloudmodel!.getVersions()) {
                        //Check Version
                        self.errorLabel.hidden = true
                        owncloudmodel!.checkNotificationRequired()
                    } else {
                        print(NSLocalizedString("errorfetchingVersions", comment: ""))
                        self.errorLabel.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.errorLabel.hidden = false
                    }
                    //Date
                    owncloudmodel!.updateDate()
                    if(!(owncloudmodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.tableView.deselectAll(self)
                    self.tableView.selectRowIndexes((NSIndexSet(index:selectedRow)), byExtendingSelection: false)
                } else if((systemInstances[instanceName] as? PiwikModel) != nil) {
                    let piwikmodel = systemInstances[instanceName] as? PiwikModel
                    //Remote Version url
                    if(piwikmodel!.getVersions()) {
                        //Check Version
                        self.errorLabel.hidden = true
                        piwikmodel!.checkNotificationRequired()
                    } else {
                        print(NSLocalizedString("errorfetchingVersions", comment: ""))
                        self.errorLabel.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.errorLabel.hidden = false
                    }
                    //Date
                    piwikmodel!.updateDate()
                    if(!(piwikmodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.tableView.deselectAll(self)
                    self.tableView.selectRowIndexes((NSIndexSet(index:selectedRow)), byExtendingSelection: false)
                } else if((systemInstances[instanceName] as? WordpressModel) != nil) {
                    let wordpressmodel = systemInstances[instanceName] as? WordpressModel
                    //Remote Version url
                    if(wordpressmodel!.getVersions()) {
                        //Check Version
                        self.errorLabel.hidden = true
                        wordpressmodel!.checkNotificationRequired()
                    } else {
                        print(NSLocalizedString("errorfetchingVersions", comment: ""))
                        self.errorLabel.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.errorLabel.hidden = false
                    }
                    //Date
                    wordpressmodel!.updateDate()
                    if(!(wordpressmodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.tableView.deselectAll(self)
                    self.tableView.selectRowIndexes((NSIndexSet(index:selectedRow)), byExtendingSelection: false)
                }
            } else {
                self.errorLabel.stringValue = NSLocalizedString("noSelectionMade", comment: "")
                self.errorLabel.hidden = false
            }
        } else {
            self.errorLabel.hidden = false
            self.refreshButton.stringValue = NSLocalizedString("retry", comment: "")
        }
        self.spinner.stopAnimation(self)
        self.spinner.hidden = true
        self.reloadTable()
    }
    
    func reloadTable() {
        let selectedRow = self.tableView.selectedRow
        self.tableView.deselectAll(self)
        outdatedInstances.removeAll()
        self.loadOutdatedInstances()
        self.tableView.reloadData()
        self.tableView.selectRowIndexes((NSIndexSet(index:selectedRow)), byExtendingSelection: false)
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        self.tableView.rowHeight = 30.0
        let cellView = tableView.makeViewWithIdentifier("InstanceName", owner: self) as! NSTableCellView
        let name = outdatedInstances[row]
        if((systemInstances[name] as? OwncloudModel) != nil) {
            cellView.imageView!.image = NSImage(named: "owncloud_dots.png")!
        } else if((systemInstances[name] as? PiwikModel) != nil) {
            cellView.imageView!.image = NSImage(named: "piwik_dots.png")!
        } else if((systemInstances[name] as? WordpressModel) != nil) {
            cellView.imageView!.image = NSImage(named: "wordpress_dots.png")!
        } else if((systemInstances[name] as? JoomlaModel) != nil) {
            cellView.imageView!.image = NSImage(named: "joomla_dots.png")!
        }
        cellView.textField?.stringValue = name
        return cellView
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.updateInstanceDetails(tableView.selectedRow)
    }
    
    func loadOutdatedInstances() {
        for instance in systemInstances.keys {
            if((systemInstances[instance] as? JoomlaModel) != nil) {
                if((systemInstances[instance] as! JoomlaModel).updateAvailable == 1) {
                    outdatedInstances.append(instance)
                }
            } else if((systemInstances[instance] as? WordpressModel) != nil) {
                if((systemInstances[instance] as! WordpressModel).updateAvailable == 1) {
                    outdatedInstances.append(instance)
                }
            } else if((systemInstances[instance] as? PiwikModel) != nil) {
                if((systemInstances[instance] as! PiwikModel).updateAvailable == 1) {
                    outdatedInstances.append(instance)
                }
            } else if((systemInstances[instance] as? OwncloudModel) != nil) {
                if((systemInstances[instance] as! OwncloudModel).updateAvailable == 1) {
                    outdatedInstances.append(instance)
                }
            }
        }
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        outdatedInstances.removeAll()
        self.loadOutdatedInstances()
        return outdatedInstances.count
    }
}
