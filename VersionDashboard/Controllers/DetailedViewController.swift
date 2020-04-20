//
//  DetailedViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class DetailedViewController: GenericViewController, NSTableViewDelegate, NSTableViewDataSource {
    
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
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var infoMessage: NSTextField!
    @IBOutlet weak var checkActiveSpinner: NSProgressIndicator!
    @IBOutlet weak var takeMeToMyInstance: NSButton!
    @IBOutlet weak var phpVersionLabel: NSTextField!
    @IBOutlet weak var phpVersion: NSTextField!
    @IBOutlet weak var webserverLabel: NSTextField!
    @IBOutlet weak var webserver: NSTextField!
    @IBOutlet weak var copyDownloadURL: NSButton!
    @IBOutlet weak var downloadUrlLabel: NSTextField!
    @IBOutlet weak var downloadUrl: NSTextField!
    @IBOutlet weak var searchfield: NSSearchField!
    var timer: Timer?
    var filtertext = String()
    var filteredInstancesArray = Array<String>()
    var summaryViewControllerItem: NSCustomTouchBarItem!
    var detailedViewControllerItem: NSCustomTouchBarItem!
    var outdatedViewControllerItem: NSCustomTouchBarItem!
    var openInstancesButtonItem: NSCustomTouchBarItem!
    var refreshInstanceButtonItem: NSCustomTouchBarItem!
    var editButtonItem: NSCustomTouchBarItem!
    var removeInstanceButtonItem: NSCustomTouchBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedViewController.reloadTable(_:)), name: NSNotification.Name(rawValue: "reloadTableContentsDetailed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailedViewController.reloadTable(_:)), name: NSNotification.Name(rawValue: "reloadTableContentsAdd"), object: nil)
        tableView.delegate = self
        tableView.dataSource = self
        self.addInstancesToTable()
        self.takeMeToMyInstance.isEnabled = false
        self.editButton.isEnabled = false
        self.removeButton.isEnabled = false
        self.copyDownloadURL.isHidden = true
        self.copyDownloadURL.isEnabled = false
        self.searchfield.placeholderString = NSLocalizedString("searchInstances", comment: "")
    }
    
    @IBAction func filterInstances(_ sender: Any) {
        self.filtertext = searchfield.stringValue.lowercased()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableContentsDetailed"), object: nil)
    }
    
    @IBAction func copyDownloadUrlToClipboard(_ sender: Any) {
        self.infoMessage.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: false)
        let owncloudhead = HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel
        if (owncloudhead.downloadurl == "") {
            infoMessage.stringValue = NSLocalizedString("clipboardCopyingFailed", comment: "")
            return
        }
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        if (pasteboard.setString(owncloudhead.downloadurl, forType: NSPasteboard.PasteboardType.string)) {
            infoMessage.stringValue = NSLocalizedString("clipboardCopyingWorked", comment: "")
        } else {
            infoMessage.stringValue = NSLocalizedString("clipboardCopyingFailed", comment: "")
        }
    }
    
    @objc func disableInfoMessage() {
        self.infoMessage.stringValue = ""
        self.infoMessage.isHidden = true
        self.timer?.invalidate()
    }
    
    @IBAction func takeMeToMyInstanceAction(_ sender: AnyObject) {
        if (!self.openInstanceWebsite(selectedRow: tableView.selectedRow, filteredInstancesArray: self.filteredInstancesArray, filtertext: self.filtertext)) {
            print("Opening website did not work")
        }
    }
    
    @IBAction func removeInstance(_ sender: AnyObject) {
        if (self.tableView.selectedRow != -1) {
            let instances = Array(SystemInstances.systemInstances.keys)
            let filename = instances[self.tableView.selectedRow]
            if (!GenericModel.deleteFile(filename)) {
                print("Deleting plist file with name \(filename) did not work.")
                return
            }
            zeroBadgeNumber()
            SystemInstances.systemInstances.removeAll()
            if (!SystemInstancesModel.loadConfigfiles()) {
                print("Loading system instances config files failed.")
                return
            }
            self.addInstancesToTable()
        }
    }
    
    func addInstancesToTable() {
        self.tableView.reloadData()
    }
    
    @objc func reloadTable(_ notification: Notification) {
        let selectedRow = self.tableView.selectedRow
        self.tableView.deselectAll(self)
        SystemInstances.systemInstances.removeAll()
        if (!SystemInstancesModel.loadConfigfiles()) {
            print("Loading system instances config files failed.")
            return
        }
        self.tableView.reloadData()
        self.tableView.selectRowIndexes((IndexSet(integer:selectedRow)), byExtendingSelection: false)
    }
    
    func updateSingleInstance(instanceName: String, completion: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            var returnValue = true
            if ((SystemInstances.systemInstances[instanceName] as? JoomlaModel) != nil) {
                let joomlamodel = SystemInstances.systemInstances[instanceName] as? JoomlaModel
                if (joomlamodel!.getVersions(forceUpdate: false)) {
                    if (joomlamodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), joomlamodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                joomlamodel!.updateDate()
                if (!(joomlamodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            } else if ((SystemInstances.systemInstances[instanceName] as? OwncloudModel) != nil) {
                let owncloudmodel = SystemInstances.systemInstances[instanceName] as? OwncloudModel
                if (owncloudmodel!.getVersions(forceUpdate: false)) {
                    if (owncloudmodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), owncloudmodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                owncloudmodel!.updateDate()
                if (!(owncloudmodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            } else if ((SystemInstances.systemInstances[instanceName] as? PiwikModel) != nil) {
                let piwikmodel = SystemInstances.systemInstances[instanceName] as? PiwikModel
                if (piwikmodel!.getVersions(forceUpdate: false)) {
                    if (piwikmodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), piwikmodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                piwikmodel!.updateDate()
                if (!(piwikmodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            } else if ((SystemInstances.systemInstances[instanceName] as? WordpressModel) != nil) {
                let wordpressmodel = SystemInstances.systemInstances[instanceName] as? WordpressModel
                if (wordpressmodel!.getVersions(forceUpdate: false)) {
                    if (wordpressmodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), wordpressmodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                wordpressmodel!.updateDate()
                if (!(wordpressmodel!.saveConfigfile())) {
                    print("Error saving plist File.")
                }
            }
            completion(returnValue)
        }
    }
    
    @IBAction func refreshInstance(_ sender: AnyObject) {
        self.checkActiveSpinner.isHidden = false
        self.checkActiveSpinner.startAnimation(self)
        if let view = self.refreshInstanceButtonItem {
            (view.view as! NSButton).isEnabled = false
        }
        if (checkInternetConnection()) {
            let selectedRow = self.tableView.selectedRow
            if (selectedRow != -1) {
                var key : String
                if (!filtertext.isEmpty) {
                    key = filteredInstancesArray[self.tableView.selectedRow]
                } else {
                    key = Array(SystemInstances.systemInstances.keys)[self.tableView.selectedRow]
                }
                self.updateSingleInstance(instanceName: key) { completion in
                    let parameters = ["self": self, "completion" : completion, "selectedRow" : selectedRow] as [String : Any]
                    self.performSelector(onMainThread: #selector(self.checksFinished), with: parameters, waitUntilDone: true)
                }
            } else {
                self.infoMessage.stringValue = NSLocalizedString("noSelectionMade", comment: "")
                self.infoMessage.isHidden = false
                self.checkActiveSpinner.stopAnimation(self)
                self.checkActiveSpinner.isHidden = true
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: true)
            }
        } else {
            self.infoMessage.stringValue = NSLocalizedString("errorInternetConnection", comment: "")
            self.infoMessage.isHidden = false
            self.refreshButton.stringValue = NSLocalizedString("retry", comment: "")
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func checksFinished(_ parameters: [String: Any]) {
        self.checkActiveSpinner.stopAnimation(parameters["self"])
        self.checkActiveSpinner.isHidden = true
        if let view = self.refreshInstanceButtonItem {
            (view.view as! NSButton).isEnabled = true
        }
        if (!(parameters["completion"] as! Bool)) {
            self.infoMessage.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
            self.infoMessage.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: true)
        } else {
            self.infoMessage.isHidden = true
        }
        self.tableView.deselectAll(parameters["self"])
        self.tableView.selectRowIndexes((IndexSet(integer:parameters["selectedRow"] as! Int)), byExtendingSelection: false)
        
        setOutdatedBadgeNumber()
    }
    
    func updateInstanceDetails(_ index: Int) {
        if ((index) != -1) {
            self.takeMeToMyInstance.isEnabled = true
            self.editButton.isEnabled = true
            self.copyDownloadURL.isHidden = true
            self.copyDownloadURL.isEnabled = false
            self.downloadUrlLabel.isHidden = true
            self.downloadUrl.isHidden = true
            self.removeButton.isEnabled = true
            if let view = self.openInstancesButtonItem {
                (view.view as! NSButton).isEnabled = true
            }
            if let view = self.refreshInstanceButtonItem {
                (view.view as! NSButton).isEnabled = true
            }
            if let view = self.editButtonItem {
                (view.view as! NSButton).isEnabled = true
            }
            if let view = self.removeInstanceButtonItem {
                (view.view as! NSButton).isEnabled = true
            }
            var key = ""
            if (!filtertext.isEmpty) {
                key = filteredInstancesArray[index]
            } else {
                key = Array(SystemInstances.systemInstances.keys)[index]
            }
            let modelclass = SystemInstances.systemInstances[key].self!
            if ((modelclass as? JoomlaModel) != nil) {
                let joomlaobject = modelclass as? JoomlaModel
                let joomlahead = HeadInstances.headInstances["Joomla"].self! as? JoomlaHeadModel
                self.hostLabel.stringValue = joomlaobject!.hosturl
                self.systemLabel.stringValue = joomlaobject!.name
                self.lastcheckLabel.stringValue = joomlaobject!.lastRefresh
                self.latestsversionLabel.stringValue = (joomlahead?.headVersion)!
                self.deployedversionLabel.stringValue = joomlaobject!.currentVersion
                self.phpVersion.stringValue = joomlaobject!.phpVersion
                self.webserver.stringValue = joomlaobject!.serverType
                if (self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if (joomlaobject!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            } else if ((modelclass as? OwncloudModel) != nil) {
                let owncloudmodel = modelclass as? OwncloudModel
                let owncloudhead = HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel
                self.latestsversionLabel.stringValue = owncloudhead.headVersion
                self.downloadUrl.stringValue = owncloudhead.downloadurl
                self.hostLabel.stringValue = owncloudmodel!.hosturl
                self.systemLabel.stringValue = owncloudmodel!.name
                self.lastcheckLabel.stringValue = owncloudmodel!.lastRefresh
                self.deployedversionLabel.stringValue = owncloudmodel!.currentVersion
                self.phpVersion.stringValue = owncloudmodel!.phpVersion
                self.webserver.stringValue = owncloudmodel!.serverType
                self.copyDownloadURL.isHidden = false
                self.downloadUrlLabel.isHidden = false
                self.downloadUrl.isHidden = false
                if (owncloudhead.downloadurl != "") {
                    self.copyDownloadURL.isEnabled = true
                }
                if (self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if (owncloudmodel!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            } else if ((modelclass as? PiwikModel) != nil) {
                let piwikmodel = modelclass as? PiwikModel
                let piwikhead = HeadInstances.headInstances["Piwik"] as! PiwikHeadModel
                self.hostLabel.stringValue = piwikmodel!.hosturl
                self.systemLabel.stringValue = piwikmodel!.name
                self.lastcheckLabel.stringValue = piwikmodel!.lastRefresh
                self.latestsversionLabel.stringValue = piwikhead.headVersion
                self.deployedversionLabel.stringValue = piwikmodel!.currentVersion
                self.phpVersion.stringValue = piwikmodel!.phpVersion
                self.webserver.stringValue = piwikmodel!.serverType
                if (self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if (piwikmodel!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            } else if ((modelclass as? WordpressModel) != nil) {
                let wordpressmodel = modelclass as? WordpressModel
                let wordpresshead = HeadInstances.headInstances["Wordpress"] as! WordpressHeadModel
                self.hostLabel.stringValue = wordpressmodel!.hosturl
                self.systemLabel.stringValue = wordpressmodel!.name
                self.lastcheckLabel.stringValue = wordpressmodel!.lastRefresh
                self.latestsversionLabel.stringValue = wordpresshead.headVersion
                self.deployedversionLabel.stringValue = wordpressmodel!.currentVersion
                self.phpVersion.stringValue = wordpressmodel!.phpVersion
                self.webserver.stringValue = wordpressmodel!.serverType
                if (self.latestsversionLabel.stringValue != "" || self.deployedversionLabel.stringValue != "") {
                    if (wordpressmodel!.updateAvailable == 0) {
                        self.statusLabel.stringValue = NSLocalizedString("ok", comment: "")
                    } else if (wordpressmodel?.updateAvailable == -1) {
                        self.statusLabel.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.statusLabel.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.statusLabel.stringValue = ""
                }
            }
            self.takeMeToMyInstance.isEnabled = true
            self.refreshButton.isEnabled = true
        } else {
            self.hostLabel.stringValue = ""
            self.systemLabel.stringValue = ""
            self.lastcheckLabel.stringValue = ""
            self.latestsversionLabel.stringValue = ""
            self.deployedversionLabel.stringValue = ""
            self.phpVersion.stringValue = ""
            self.webserver.stringValue = ""
            self.statusLabel.stringValue = ""
            self.downloadUrl.stringValue = ""
            self.editButton.isEnabled = false
            self.removeButton.isEnabled = false
            self.copyDownloadURL.isHidden = true
            self.copyDownloadURL.isEnabled = false
            self.takeMeToMyInstance.isEnabled = false
            self.refreshButton.isEnabled = false
            self.downloadUrlLabel.isHidden = true
            self.downloadUrl.isHidden = true
            if let view = self.openInstancesButtonItem {
                (view.view as! NSButton).isEnabled = false
            }
            if let view = self.refreshInstanceButtonItem {
                (view.view as! NSButton).isEnabled = false
            }
            if let view = self.editButtonItem {
                (view.view as! NSButton).isEnabled = false
            }
            if let view = self.removeInstanceButtonItem {
                (view.view as! NSButton).isEnabled = false
            }
        }
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return createTableCell(tableView: self.tableView, filteredInstancesArray: filteredInstancesArray, row: row)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updateInstanceDetails(tableView.selectedRow)
    }
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        if (!filtertext.isEmpty) {
            filteredInstancesArray.removeAll()
            for systemInstance in SystemInstances.systemInstances.keys {
                let systemInstanceLower = systemInstance.lowercased()
                if (systemInstanceLower.range(of: filtertext, options: .regularExpression) != nil) {
                    filteredInstancesArray.append(systemInstance)
                }
            }
            return filteredInstancesArray.count
        }
        filteredInstancesArray = Array(SystemInstances.systemInstances.keys)
        return SystemInstances.systemInstances.count
    }
    
    @IBAction func loadAddViewController(_: Any) {
        let myWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "AddSystemViewController") as? AddSystemViewController
        if (myWindowController == nil) {
            print("Instantiating add system view controller did not work.")
            return
        }
        presentAsSheet(myWindowController!)
    }
    
    @IBAction func loadSettingsViewController(_: Any) {
        let myWindowController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SettingsViewController") as? SettingsViewController
        if (myWindowController == nil) {
            print("Instantiating settings view controller did not work.")
            return
        }
        myWindowController!.instanceName = self.systemLabel.stringValue
        presentAsSheet(myWindowController!)
    }
}

/**
 NSTouchBarDelegate extension for view controller.
 */
extension DetailedViewController: NSTouchBarDelegate {
    /**
     Generates a custom TouchBar.
     
     - Returns: Custom NSTouchBar.
     */
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarDetailed
        touchBar.defaultItemIdentifiers = [.addNewInstance, .removeInstance, .editInstance, .refreshInstance, .openInstanceWebsite, .flexibleSpace, .summaryViewController, .outdatedViewController]
        touchBar.customizationAllowedItemIdentifiers = [.addNewInstance, .removeInstance, .editInstance, .refreshInstance, .openInstanceWebsite, .summaryViewController, .outdatedViewController]
        return touchBar
    }
    
    /**
     Creates DetailedViewController specific TouchBar buttons.
     
     - Parameters:
     - touchBar: TouchBar to be added to
     - identifier: NSTouchBarItem identifier.
     - Returns: NSTouchBarItem to be added to TouchBar, nil in case of failure.
     */
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItem.Identifier.addNewInstance:
            let addInstanceButtonItem = NSCustomTouchBarItem(identifier: identifier)
            let addButton = NSButton(image: NSImage(named: NSImage.addTemplateName)!, target: self, action: #selector(self.loadAddViewController))
            addInstanceButtonItem.view = addButton
            return addInstanceButtonItem
        case NSTouchBarItem.Identifier.removeInstance:
            self.removeInstanceButtonItem = NSCustomTouchBarItem(identifier: identifier)
            let removeButton = NSButton(image: NSImage(named: NSImage.removeTemplateName)!, target: self, action: #selector(self.removeInstance))
            removeButton.isEnabled = false
            removeInstanceButtonItem.view = removeButton
            return removeInstanceButtonItem
        case NSTouchBarItem.Identifier.editInstance:
            self.editButtonItem = NSCustomTouchBarItem(identifier: identifier)
            let editButton = NSButton(image: NSImage(named: NSImage.smartBadgeTemplateName)!, target: self, action: #selector(self.loadSettingsViewController))
            editButton.isEnabled = false
            editButtonItem.view = editButton
            return editButtonItem
        case NSTouchBarItem.Identifier.refreshInstance:
            self.refreshInstanceButtonItem = NSCustomTouchBarItem(identifier: identifier)
            let refreshButton = NSButton(image: NSImage(named: NSImage.refreshTemplateName)!, target: self, action: #selector(self.refreshInstance))
            refreshButton.isEnabled = false
            refreshInstanceButtonItem.view = refreshButton
            return refreshInstanceButtonItem
        case NSTouchBarItem.Identifier.summaryViewController:
            self.summaryViewControllerItem = NSCustomTouchBarItem(identifier: identifier)
            let summaryButton = NSButton(image: NSImage(named: NSImage.Name("Summarize.png"))!, target: self, action: #selector(GenericViewController.loadSummaryViewController))
            self.summaryViewControllerItem.view = summaryButton
            return self.summaryViewControllerItem
        case NSTouchBarItem.Identifier.outdatedViewController:
            self.outdatedViewControllerItem = NSCustomTouchBarItem(identifier: identifier)
            let outdatedButton = NSButton(image: NSImage(named: NSImage.Name("Outdated item.png"))!, target: self, action: #selector(GenericViewController.loadOutdatedViewController))
            self.outdatedViewControllerItem.view = outdatedButton
            return self.outdatedViewControllerItem
        case NSTouchBarItem.Identifier.openInstanceWebsite:
            self.openInstancesButtonItem = NSCustomTouchBarItem(identifier: identifier)
            let openButton = NSButton(image: NSImage(named: NSImage.homeTemplateName)!, target: self, action: #selector(DetailedViewController.takeMeToMyInstanceAction))
            openButton.isEnabled = false
            openInstancesButtonItem.view = openButton
            return openInstancesButtonItem
        default:
            return nil
        }
    }
}
