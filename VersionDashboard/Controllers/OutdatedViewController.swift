//
//  OutdatedViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 28.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

class OutdatedViewController: GenericViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var table: NSScrollView!
    @IBOutlet weak var latestVersion: NSTextField!
    @IBOutlet weak var currentVersion: NSTextField!
    @IBOutlet weak var lastcheck: NSTextField!
    @IBOutlet weak var status: NSTextField!
    @IBOutlet weak var hostName: NSTextField!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var systemName: NSTextField!
    @IBOutlet weak var latestVersionLabel: NSTextField!
    @IBOutlet weak var currentVersionLabel: NSTextField!
    @IBOutlet weak var lastCheckLabel: NSTextField!
    @IBOutlet weak var infoMessage: NSTextField!
    @IBOutlet weak var hostLabel: NSTextField!
    @IBOutlet weak var systemLabel: NSTextField!
    @IBOutlet weak var refreshButton: NSButton!
    @IBOutlet weak var spinner: NSProgressIndicator!
    @IBOutlet weak var phpVersionLabel: NSTextField!
    @IBOutlet weak var phpVersion: NSTextField!
    @IBOutlet weak var webserverLabel: NSLayoutConstraint!
    @IBOutlet weak var webserver: NSTextField!
    @IBOutlet weak var takeMeToMyInstance: NSButton!
    @IBOutlet weak var copyDownloadURL: NSButton!
    @IBOutlet weak var downloadUrlLabel: NSTextField!
    @IBOutlet weak var downloadUrl: NSTextField!
    @IBOutlet weak var searchfield: NSSearchFieldCell!
    @IBOutlet weak var searchfieldbar: NSSearchField!
    var timer: Timer?
    var filtertext = String()
    var filteredInstancesArray = Array<String>()
    var summaryViewControllerItem: NSCustomTouchBarItem!
    var detailedViewControllerItem: NSCustomTouchBarItem!
    var outdatedViewControllerItem: NSCustomTouchBarItem!
    var editButtonItem: NSCustomTouchBarItem!
    var refreshInstanceButtonItem: NSCustomTouchBarItem!
    var openInstanceButtonItem: NSCustomTouchBarItem!
    
    override func viewDidLoad() {
        OutdatedInstances.outdatedInstances.removeAll()
        tableView.delegate = self
        tableView.dataSource = self
        self.searchfield.placeholderString = NSLocalizedString("searchInstances", comment: "")
        NotificationCenter.default.addObserver(self, selector: #selector(OutdatedViewController.activateSearchBar(_:)), name: NSNotification.Name(rawValue: "activateSearchBar"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OutdatedViewController.copyContent(_:)), name: NSNotification.Name(rawValue: "copyContent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OutdatedViewController.cutContent(_:)), name: NSNotification.Name(rawValue: "cutContent"), object: nil)
    }
    
    @IBAction func filterInstances(_ sender: Any) {
        self.filtertext = searchfield.stringValue.lowercased()
        self.reloadTable()
    }
    
    @objc func disableInfoMessage() {
        self.infoMessage.stringValue = ""
        self.infoMessage.isHidden = true
        self.timer?.invalidate()
    }
    
    @objc func cutContent(_ notification: Notification) {
        _ = self.copyStringToClipboard(string: self.searchfieldbar!.stringValue)
        self.searchfieldbar.stringValue = ""
    }
    
    @objc func copyContent(_ notification: Notification) {
        _ = self.copyStringToClipboard(string: self.searchfieldbar!.stringValue)
    }
    
    @IBAction func copyDownloadUrlToClipboard(_ sender: Any) {
        self.infoMessage.isHidden = false
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: false)
        if (self.copyStringToClipboard(string: self.downloadUrl.stringValue)) {
            infoMessage.stringValue = NSLocalizedString("clipboardCopyingWorked", comment: "")
        } else {
            infoMessage.stringValue = NSLocalizedString("clipboardCopyingFailed", comment: "")
        }
    }
    
    func updateInstanceDetails(_ index: Int) {
        if ((index) != -1) {
            var key = ""
            if (!filtertext.isEmpty) {
                key = filteredInstancesArray[index]
            } else {
                key = OutdatedInstances.outdatedInstances[index]
            }
            
            if let view = self.openInstanceButtonItem {
                (view.view as! NSButton).isEnabled = true
            }
            if let view = self.refreshInstanceButtonItem {
                (view.view as! NSButton).isEnabled = true
            }
            if let view = self.editButtonItem {
                (view.view as! NSButton).isEnabled = true
            }
            
            let modelclass = SystemInstances.systemInstances[key].self!
            if ((modelclass as? JoomlaModel) != nil) {
                let joomlaobject = modelclass as? JoomlaModel
                self.hostName.stringValue = joomlaobject!.hosturl
                self.systemName.stringValue = joomlaobject!.name
                self.lastcheck.stringValue = joomlaobject!.lastRefresh
                self.latestVersion.stringValue = joomlaobject!.headVersion
                self.currentVersion.stringValue = joomlaobject!.currentVersion
                self.phpVersion.stringValue = joomlaobject!.phpVersion
                self.webserver.stringValue = joomlaobject!.serverType
                if (self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if (joomlaobject!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if (joomlaobject?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            } else if ((modelclass as? OwncloudModel) != nil) {
                let owncloudmodel = modelclass as? OwncloudModel
                let owncloudhead = HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel
                self.hostName.stringValue = owncloudmodel!.hosturl
                self.systemName.stringValue = owncloudmodel!.name
                self.lastcheck.stringValue = owncloudmodel!.lastRefresh
                self.latestVersion.stringValue = owncloudmodel!.headVersion
                self.currentVersion.stringValue = owncloudmodel!.currentVersion
                self.phpVersion.stringValue = owncloudmodel!.phpVersion
                self.webserver.stringValue = owncloudmodel!.serverType
                self.downloadUrl.stringValue = owncloudhead.downloadurl
                self.copyDownloadURL.isHidden = false
                self.downloadUrlLabel.isHidden = false
                self.downloadUrl.isHidden = false
                if (owncloudhead.downloadurl != "") {
                    self.copyDownloadURL.isEnabled = true
                }
                if (self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if (owncloudmodel!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if (owncloudmodel?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            } else if ((modelclass as? NextcloudModel) != nil) {
                let nextcloudmodel = modelclass as? NextcloudModel
                let nextcloudhead = HeadInstances.headInstances["Nextcloud"] as! NextcloudHeadModel
                self.hostName.stringValue = nextcloudmodel!.hosturl
                self.systemName.stringValue = nextcloudmodel!.name
                self.lastcheck.stringValue = nextcloudmodel!.lastRefresh
                self.latestVersion.stringValue = nextcloudmodel!.headVersion
                self.currentVersion.stringValue = nextcloudmodel!.currentVersion
                self.phpVersion.stringValue = nextcloudmodel!.phpVersion
                self.webserver.stringValue = nextcloudmodel!.serverType
                self.downloadUrl.stringValue = nextcloudhead.downloadurl
                self.copyDownloadURL.isHidden = false
                self.downloadUrlLabel.isHidden = false
                self.downloadUrl.isHidden = false
                if (nextcloudhead.downloadurl != "") {
                    self.copyDownloadURL.isEnabled = true
                }
                if (self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if (nextcloudmodel!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if (nextcloudmodel?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            } else if ((modelclass as? PiwikModel) != nil) {
                let piwikmodel = modelclass as? PiwikModel
                self.hostName.stringValue = piwikmodel!.hosturl
                self.systemName.stringValue = piwikmodel!.name
                self.lastcheck.stringValue = piwikmodel!.lastRefresh
                self.latestVersion.stringValue = piwikmodel!.headVersion
                self.currentVersion.stringValue = piwikmodel!.currentVersion
                self.phpVersion.stringValue = piwikmodel!.phpVersion
                self.webserver.stringValue = piwikmodel!.serverType
                if (self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if (piwikmodel!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if (piwikmodel?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            } else if ((modelclass as? WordpressModel) != nil) {
                let wordpressmodel = modelclass as? WordpressModel
                self.hostName.stringValue = wordpressmodel!.hosturl
                self.systemName.stringValue = wordpressmodel!.name
                self.lastcheck.stringValue = wordpressmodel!.lastRefresh
                self.latestVersion.stringValue = wordpressmodel!.headVersion
                self.currentVersion.stringValue = wordpressmodel!.currentVersion
                self.phpVersion.stringValue = wordpressmodel!.phpVersion
                self.webserver.stringValue = wordpressmodel!.serverType
                if (self.latestVersion.stringValue != "" || self.currentVersion.stringValue != "") {
                    if (wordpressmodel!.updateAvailable == 0) {
                        self.status.stringValue = NSLocalizedString("ok", comment: "")
                    } else if (wordpressmodel?.updateAvailable == -1) {
                        self.status.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
                    } else {
                        self.status.stringValue = NSLocalizedString("updateavailable", comment: "")
                    }
                } else {
                    self.status.stringValue = ""
                }
            }
            self.takeMeToMyInstance.isEnabled = true
            self.refreshButton.isEnabled = true
        } else {
            self.takeMeToMyInstance.isEnabled = false
            self.refreshButton.isEnabled = false
            self.hostName.stringValue = ""
            self.systemName.stringValue = ""
            self.lastcheck.stringValue = ""
            self.latestVersion.stringValue = ""
            self.currentVersion.stringValue = ""
            self.phpVersion.stringValue = ""
            self.webserver.stringValue = ""
            self.status.stringValue = ""
            if let view = self.openInstanceButtonItem {
                (view.view as! NSButton).isEnabled = false
            }
            if let view = self.refreshInstanceButtonItem {
                (view.view as! NSButton).isEnabled = false
            }
            if let view = self.editButtonItem {
                (view.view as! NSButton).isEnabled = false
            }
        }
    }
    
    @objc func activateSearchBar(_ notification: Notification) {
        self.searchfieldbar.selectText(self)
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
            } else if ((SystemInstances.systemInstances[instanceName] as? NextcloudModel) != nil) {
                let nextcloudmodel = SystemInstances.systemInstances[instanceName] as? NextcloudModel
                if (nextcloudmodel!.getVersions(forceUpdate: false)) {
                    if (nextcloudmodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), nextcloudmodel!.name)))
                    }
                } else {
                    returnValue = false
                }
                nextcloudmodel!.updateDate()
                if (!(nextcloudmodel!.saveConfigfile())) {
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
        self.spinner.isHidden = false
        self.spinner.startAnimation(self)
        if (checkInternetConnection()) {
            let selectedRow = tableView.selectedRow
            if (selectedRow != -1) {
                let instanceName = OutdatedInstances.outdatedInstances[selectedRow]
                self.updateSingleInstance(instanceName: instanceName) { completion in
                    let parameters = ["self": self, "completion" : completion, "selectedRow" : selectedRow] as [String : Any]
                    self.performSelector(onMainThread: #selector(self.checksFinished), with: parameters, waitUntilDone: true)
                }
            } else {
                self.infoMessage.stringValue = NSLocalizedString("noSelectionMade", comment: "")
                self.infoMessage.isHidden = false
                self.spinner.stopAnimation(self)
                self.spinner.isHidden = true
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: true)
            }
        } else {
            self.infoMessage.isHidden = false
            self.refreshButton.stringValue = NSLocalizedString("retry", comment: "")
            self.infoMessage.stringValue = NSLocalizedString("errorInternetConnection", comment: "")
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: true)
        }
        self.reloadTable()
    }
    
    @IBAction func takeMeToMyInstanceAction(_ sender: AnyObject) {
        if (!self.openInstanceWebsite(selectedRow: tableView.selectedRow, filteredInstancesArray: self.filteredInstancesArray, filtertext: self.filtertext)) {
            print("Opening website did not work")
        }
    }

    @objc func checksFinished(_ parameters: [String: Any]) {
        self.spinner.stopAnimation(parameters["self"])
        self.spinner.isHidden = true
        if (!(parameters["completion"] as! Bool)) {
            self.infoMessage.stringValue = NSLocalizedString("errorfetchingVersions", comment: "")
            self.infoMessage.isHidden = false
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(Constants.timerInterval), target: self, selector: #selector(disableInfoMessage), userInfo: nil, repeats: true)
        } else {
            self.infoMessage.isHidden = true
        }
        self.tableView.deselectAll(parameters["self"])
        self.tableView.selectRowIndexes((IndexSet(integer:parameters["selectedRow"] as! Int)), byExtendingSelection: false)
        reloadTable()
        
        setOutdatedBadgeNumber()
    }
    
    func reloadTable() {
        let selectedRow = self.tableView.selectedRow
        self.tableView.deselectAll(self)
        
        OutdatedInstances.outdatedInstances.removeAll()
        self.loadOutdatedInstances()
        
        self.tableView.reloadData()
        self.tableView.selectRowIndexes((IndexSet(integer:selectedRow)), byExtendingSelection: false)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return createTableCell(tableView: self.tableView, filteredInstancesArray: filteredInstancesArray, row: row)
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.updateInstanceDetails(tableView.selectedRow)
    }
    
    func loadOutdatedInstances() {
        for instance in SystemInstances.systemInstances.keys {
            if ((SystemInstances.systemInstances[instance] as? JoomlaModel) != nil) {
                if ((SystemInstances.systemInstances[instance] as! JoomlaModel).updateAvailable == 1) {
                    OutdatedInstances.outdatedInstances.append(instance)
                }
            } else if ((SystemInstances.systemInstances[instance] as? WordpressModel) != nil) {
                if ((SystemInstances.systemInstances[instance] as! WordpressModel).updateAvailable == 1) {
                    OutdatedInstances.outdatedInstances.append(instance)
                }
            } else if ((SystemInstances.systemInstances[instance] as? PiwikModel) != nil) {
                if ((SystemInstances.systemInstances[instance] as! PiwikModel).updateAvailable == 1) {
                    OutdatedInstances.outdatedInstances.append(instance)
                }
            } else if ((SystemInstances.systemInstances[instance] as? OwncloudModel) != nil) {
                if ((SystemInstances.systemInstances[instance] as! OwncloudModel).updateAvailable == 1) {
                    OutdatedInstances.outdatedInstances.append(instance)
                }
            }  else if ((SystemInstances.systemInstances[instance] as? NextcloudModel) != nil) {
                if ((SystemInstances.systemInstances[instance] as! NextcloudModel).updateAvailable == 1) {
                    OutdatedInstances.outdatedInstances.append(instance)
                }
            }
        }
    }
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        OutdatedInstances.outdatedInstances.removeAll()
        self.loadOutdatedInstances()
        
        if (!filtertext.isEmpty) {
            filteredInstancesArray.removeAll()
            for systemInstance in OutdatedInstances.outdatedInstances {
                let systemInstanceLower = systemInstance.lowercased()
                if (systemInstanceLower.range(of: filtertext, options: .regularExpression) != nil) {
                    filteredInstancesArray.append(systemInstance)
                }
            }
            return filteredInstancesArray.count
        }
        filteredInstancesArray = OutdatedInstances.outdatedInstances
        return OutdatedInstances.outdatedInstances.count
    }
    
}

/**
 NSTouchBarDelegate extension for view controller.
 */
extension OutdatedViewController: NSTouchBarDelegate {
    /**
     Generates a custom TouchBar.
     
     - Returns: Custom NSTouchBar.
     */
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarOutdated
        touchBar.defaultItemIdentifiers =        [.refreshInstance, .openInstanceWebsite, .flexibleSpace, .summaryViewController, .detailedViewController]
        touchBar.customizationAllowedItemIdentifiers = [.refreshInstance, .openInstanceWebsite, .summaryViewController, .detailedViewController]
        return touchBar
    }
    
    /**
     Creates OutdatedViewController specific TouchBar buttons.
     
     - Parameters:
     - touchBar: TouchBar to be added to
     - identifier: NSTouchBarItem identifier.
     - Returns: NSTouchBarItem to be added to TouchBar, nil in case of failure.
     */
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItem.Identifier.refreshInstance:
            self.refreshInstanceButtonItem = NSCustomTouchBarItem(identifier: identifier)
            let refreshButton = NSButton(image: NSImage(named: NSImage.refreshTemplateName)!, target: self, action: #selector(self.refreshInstance))
            refreshButton.isEnabled = false
            self.refreshInstanceButtonItem.view = refreshButton
            return self.refreshInstanceButtonItem
        case NSTouchBarItem.Identifier.summaryViewController:
            self.summaryViewControllerItem = NSCustomTouchBarItem(identifier: identifier)
            let summaryButton = NSButton(image: NSImage(named: NSImage.Name("Summarize.png"))!, target: self, action: #selector(GenericViewController.loadSummaryViewController))
            self.summaryViewControllerItem.view = summaryButton
            return self.summaryViewControllerItem
        case NSTouchBarItem.Identifier.detailedViewController:
            self.detailedViewControllerItem = NSCustomTouchBarItem(identifier: identifier)
            let detailedButton = NSButton(image: NSImage(named: NSImage.Name("Detailed view.png"))!, target: self, action: #selector(GenericViewController.loadDetailedViewController))
            self.detailedViewControllerItem.view = detailedButton
            return self.detailedViewControllerItem
        case NSTouchBarItem.Identifier.openInstanceWebsite:
            self.openInstanceButtonItem = NSCustomTouchBarItem(identifier: identifier)
            let openButton = NSButton(image: NSImage(named: NSImage.homeTemplateName)!, target: self, action: #selector(self.takeMeToMyInstanceAction))
            openButton.isEnabled = false
            self.openInstanceButtonItem.view = openButton
            return self.openInstanceButtonItem
        default:
            return nil
        }
    }
}
