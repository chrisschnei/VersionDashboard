//
//  DetailedViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class DetailedViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
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
    @IBOutlet weak var takeMeToMyInstance: NSButton!
    @IBOutlet weak var phpVersionLabel: NSTextField!
    @IBOutlet weak var phpVersion: NSTextField!
    @IBOutlet weak var webserverLabel: NSLayoutConstraint!
    @IBOutlet weak var webserver: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedViewController.reloadTable(_:)), name: NSNotification.Name(rawValue: "load"), object: nil)
        systemTableView.delegate = self
        systemTableView.dataSource = self
        self.addInstancesToTable()
        self.takeMeToMyInstance.isEnabled = false
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if(self.systemTableView.selectedRow != -1) {
            let button = sender as! NSButton
            if (((button.title) == NSLocalizedString("edit", comment:"")) || ((button.title) == NSLocalizedString("edit", comment:""))) {
                let instances = Array(systemInstances.keys)
                let instanceNa = instances[self.systemTableView.selectedRow]
                let destination = segue.destinationController as! SettingsViewController
                destination.instanceName = instanceNa
            }
        }
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
    @IBAction func takeMeToMyInstance(_ sender: AnyObject) {
        if(self.systemTableView.selectedRow != -1) {
            let instancename = Array(systemInstances.keys)[self.systemTableView.selectedRow]
            let instance = systemInstances[instancename]
            var url = ""
            if((instance as? JoomlaModel) != nil) {
                url = (instance as! JoomlaModel).hosturl + joomlaBackendURL
            } else if((instance as? WordpressModel) != nil) {
                url = (instance as! WordpressModel).hosturl + wordpressBackendURL
            } else if((instance as? PiwikModel) != nil) {
                url = (instance as! PiwikModel).hosturl
            } else if((instance as? OwncloudModel) != nil) {
                url = (instance as! OwncloudModel).hosturl
            }
            NSWorkspace.shared().open(URL(string: url)!)
        }
    }
    
    func deleteFile(_ path: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Error deleting plist file: \(error)")
        }
    }
    
    @IBAction func removeInstance(_ sender: AnyObject) {
        if(self.systemTableView.selectedRow != -1) {
            let instances = Array(systemInstances.keys)
            let filename = instances[self.systemTableView.selectedRow]
            let path = (plistFilesPath + filename) + ".plist"
            self.deleteFile(path)
            zeroBadgeNumber()
            systemInstances.removeAll()
            SystemInstancesModel().loadConfigfiles()
            self.addInstancesToTable()
        }
    }
    
    func addInstancesToTable() {
        self.systemTableView.reloadData()
    }
    
    func reloadTable(_ notification: Notification) {
        let selectedRow = self.systemTableView.selectedRow
        self.systemTableView.deselectAll(self)
        systemInstances.removeAll()
        SystemInstancesModel().loadConfigfiles()
        self.systemTableView.reloadData()
        self.systemTableView.selectRowIndexes((IndexSet(integer:selectedRow)), byExtendingSelection: false)
    }
    
    @IBAction func refreshInstance(_ sender: AnyObject) {
        self.checkActiveSpinner.isHidden = false
        self.checkActiveSpinner.startAnimation(self)
        if(checkInternetConnection()) {
            let selectedRow = systemTableView.selectedRow
            if(selectedRow != -1) {
                let instanceName = Array(systemInstances.keys)[selectedRow]
                if((systemInstances[instanceName] as? JoomlaModel) != nil) {
                    let joomlamodel = systemInstances[instanceName] as? JoomlaModel
                    //Remote Version url
                    if(joomlamodel!.getVersions()) {
                        //Check Version
                        self.noInternetConnection.isHidden = true
                        joomlamodel!.checkNotificationRequired()
                    } else {
                        self.noInternetConnection.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.noInternetConnection.isHidden = false
                    }
                    //Date
                    joomlamodel!.updateDate()
                    if(!(joomlamodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.systemTableView.deselectAll(self)
                    self.systemTableView.selectRowIndexes((IndexSet(integer:selectedRow)), byExtendingSelection: false)
                } else if((systemInstances[instanceName] as? OwncloudModel) != nil) {
                    let owncloudmodel = systemInstances[instanceName] as? OwncloudModel
                    //Remote Version url
                    if(owncloudmodel!.getVersions()) {
                        //Check Version
                        self.noInternetConnection.isHidden = true
                        owncloudmodel!.checkNotificationRequired()
                    } else {
                        self.noInternetConnection.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.noInternetConnection.isHidden = false
                    }
                    //Date
                    owncloudmodel!.updateDate()
                    if(!(owncloudmodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.systemTableView.deselectAll(self)
                    self.systemTableView.selectRowIndexes((IndexSet(integer:selectedRow)), byExtendingSelection: false)
                } else if((systemInstances[instanceName] as? PiwikModel) != nil) {
                    let piwikmodel = systemInstances[instanceName] as? PiwikModel
                    //Remote Version url
                    if(piwikmodel!.getVersions()) {
                        //Check Version
                        self.noInternetConnection.isHidden = true
                        piwikmodel!.checkNotificationRequired()
                    } else {
                        self.noInternetConnection.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.noInternetConnection.isHidden = false
                    }
                    //Date
                    piwikmodel!.updateDate()
                    if(!(piwikmodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.systemTableView.deselectAll(self)
                    self.systemTableView.selectRowIndexes((IndexSet(integer:selectedRow)), byExtendingSelection: false)
                } else if((systemInstances[instanceName] as? WordpressModel) != nil) {
                    let wordpressmodel = systemInstances[instanceName] as? WordpressModel
                    //Remote Version url
                    if(wordpressmodel!.getVersions()) {
                        //Check Version
                        self.noInternetConnection.isHidden = true
                        wordpressmodel!.checkNotificationRequired()
                    } else {
                        self.noInternetConnection.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                        self.noInternetConnection.isHidden = false
                    }
                    //Date
                    wordpressmodel!.updateDate()
                    if(!(wordpressmodel!.saveConfigfile())) {
                        print("Error saving plist File.")
                    }
                    self.systemTableView.deselectAll(self)
                    self.systemTableView.selectRowIndexes((IndexSet(integer:selectedRow)), byExtendingSelection: false)
                }
            } else {
                self.noInternetConnection.stringValue = NSLocalizedString("noSelectionMade", comment: "")
                self.noInternetConnection.isHidden = false
            }
        } else {
            self.noInternetConnection.stringValue = NSLocalizedString("errorInternetConnection", comment: "")
            self.noInternetConnection.isHidden = false
            self.refreshButton.stringValue = NSLocalizedString("retry", comment: "")
        }
        self.checkActiveSpinner.stopAnimation(self)
        self.checkActiveSpinner.isHidden = true
    }
    
    func updateInstanceDetails(_ index: Int) {
        if((index) != -1) {
            self.takeMeToMyInstance.isEnabled = true
            let key = Array(systemInstances.keys)[index]
            let modelclass = systemInstances[key].self!
            if((modelclass as? JoomlaModel) != nil) {
                let joomlaobject = modelclass as? JoomlaModel
                self.hostLabel.stringValue = joomlaobject!.hosturl
                self.systemLabel.stringValue = joomlaobject!.name
                self.lastcheckLabel.stringValue = joomlaobject!.lastRefresh
                self.latestsversionLabel.stringValue = joomlaobject!.headVersion
                self.deployedversionLabel.stringValue = joomlaobject!.currentVersion
                self.phpVersion.stringValue = joomlaobject!.phpVersion
                self.webserver.stringValue = joomlaobject!.serverType
                if(self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if(joomlaobject!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            } else if((modelclass as? OwncloudModel) != nil) {
                let owncloudmodel = modelclass as? OwncloudModel
                self.hostLabel.stringValue = owncloudmodel!.hosturl
                self.systemLabel.stringValue = owncloudmodel!.name
                self.lastcheckLabel.stringValue = owncloudmodel!.lastRefresh
                self.latestsversionLabel.stringValue = owncloudmodel!.headVersion
                self.deployedversionLabel.stringValue = owncloudmodel!.currentVersion
                self.phpVersion.stringValue = owncloudmodel!.phpVersion
                self.webserver.stringValue = owncloudmodel!.serverType
                if(self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if(owncloudmodel!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            } else if((modelclass as? PiwikModel) != nil) {
                let piwikmodel = modelclass as? PiwikModel
                self.hostLabel.stringValue = piwikmodel!.hosturl
                self.systemLabel.stringValue = piwikmodel!.name
                self.lastcheckLabel.stringValue = piwikmodel!.lastRefresh
                self.latestsversionLabel.stringValue = piwikmodel!.headVersion
                self.deployedversionLabel.stringValue = piwikmodel!.currentVersion
                self.phpVersion.stringValue = piwikmodel!.phpVersion
                self.webserver.stringValue = piwikmodel!.serverType
                if(self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if(piwikmodel!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            } else if((modelclass as? WordpressModel) != nil) {
                let wordpressmodel = modelclass as? WordpressModel
                self.hostLabel.stringValue = wordpressmodel!.hosturl
                self.systemLabel.stringValue = wordpressmodel!.name
                self.lastcheckLabel.stringValue = wordpressmodel!.lastRefresh
                self.latestsversionLabel.stringValue = wordpressmodel!.headVersion
                self.deployedversionLabel.stringValue = wordpressmodel!.currentVersion
                self.phpVersion.stringValue = wordpressmodel!.phpVersion
                self.webserver.stringValue = wordpressmodel!.serverType
                if(self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if(wordpressmodel!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else if(wordpressmodel?.updateAvailable == -1) {
                        self.statusLabel.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            }
        } else {
            self.takeMeToMyInstance.isEnabled = false
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        self.systemTableView.rowHeight = 30.0
        let cellView = tableView.make(withIdentifier: "InstanceName", owner: self) as! NSTableCellView
        let instancesArray = Array(systemInstances.keys)
        let name = instancesArray[row]
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
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updateInstanceDetails(systemTableView.selectedRow)
    }
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        return systemInstances.count
    }
    
}

