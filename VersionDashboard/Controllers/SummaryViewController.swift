//
//  SummaryViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation
import Cocoa
import Charts
import VersionDashboardSDK

/**
 SummaryViewController class representing main view controller.
 */
class SummaryViewController: GenericViewController {

    @IBOutlet weak var checkAllInstancesButton: NSButton!
    @IBOutlet var summaryViewController: NSView!
    @IBOutlet weak var refreshActiveSpinner: NSProgressIndicator!
    @IBOutlet weak var pieChartInstanceSummary: PieChartView!
    @IBOutlet weak var pieChartInstanceOutdated: PieChartView!
    var touchbarPreferencesItem: NSCustomTouchBarItem!
    var touchbarRefreshItem: NSCustomTouchBarItem!
    var touchbarSummaryInstancesItem: NSCustomTouchBarItem!
    var summaryViewControllerItem: NSCustomTouchBarItem!
    var detailedViewControllerItem: NSCustomTouchBarItem!
    var outdatedViewControllerItem: NSCustomTouchBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(SummaryViewController.forceCheckAllInstances(_:)), name: NSNotification.Name(rawValue: "forceUpdateInstances"), object: nil)
        
        Constants.initialize(Bundle.main.bundlePath)
        
        PreferencesViewController().loadConfigurationFile()
        if (HeadInstances.headInstances.count == 0) {
            if (!HeadInstancesModel.loadConfigfiles()) {
                print("Loading head instances config files failed.")
            }
        }
        if (SystemInstances.systemInstances.count == 0) {
            if (!SystemInstancesModel.loadConfigfiles()) {
                print("Loading system instances config files failed.")
            }
        }
        if ((ConfigurationSettings.configurationSettings["automaticRefreshActive"] as! Bool) == true) {
            PreferencesViewController().automaticRefresh()
        }
        self.drawPieChartInstances()
        self.drawPieChartOutdated()
        
        setOutdatedBadgeNumber()
    }
    
    /**
     Draws a pie chart containing all instances.
     */
    func drawPieChartInstances() {
        var chartdata = Array<PieChartDataEntry>()
        for (instancename, amount) in SystemInstancesModel.checkAllInstancesTypes() {
            chartdata.append(PieChartDataEntry(value: Double(amount), label:instancename))
        }
        
        let data = PieChartData()
        let ds1 = PieChartDataSet(entries: chartdata, label:"")
        ds1.colors = ChartColorTemplates.material()
        data.addDataSet(ds1)
        self.pieChartInstanceSummary.data = data
        self.pieChartInstanceSummary.chartDescription?.text = ""
    }
    
    /**
     Draws a pie chart containing outdated instances information.
     */
    func drawPieChartOutdated() {
        var chartdata = Array<PieChartDataEntry>()
        chartdata.append(PieChartDataEntry(value: Double(SystemInstancesModel.getAmountOfOutdateInstances()), label: NSLocalizedString("outdated", comment: "")))
        chartdata.append(PieChartDataEntry(value: Double(SystemInstancesModel.getAmountOfUptodateInstances()), label:  NSLocalizedString("uptodate", comment: "")))
        
        let data = PieChartData()
        let ds1 = PieChartDataSet(entries: chartdata, label:"")
        ds1.colors = ChartColorTemplates.colorful()
        data.addDataSet(ds1)
        self.pieChartInstanceOutdated.data = data
        self.pieChartInstanceOutdated.chartDescription?.text = ""
    }
    
    /**
     Callback function execute on finished instances refresh.
     */
    @objc func checksFinished() {
        self.refreshActiveSpinner.stopAnimation(self)
        self.refreshActiveSpinner.isHidden = true
        if let view = self.touchbarRefreshItem {
            (view.view as! NSButton).isEnabled = true
        }
        
        SystemInstances.systemInstances.removeAll()
        if (!SystemInstancesModel.loadConfigfiles()) {
            print("Loading system instances config files failed.")
        }
        self.drawPieChartInstances()
        self.drawPieChartOutdated()
        
        setOutdatedBadgeNumber()
    }
    
    /**
     Callback run at the beginning of instances refresh.
     
     - Parameters:
     - sender: Sending object.
     */
    @IBAction func checkAllInstances(_ sender: AnyObject) {
        self.refreshActiveSpinner.isHidden = false
        self.refreshActiveSpinner.startAnimation(self)
        if let view = self.touchbarRefreshItem {
            (view.view as! NSButton).isEnabled = false
        }
        SummaryViewController.checkAllInstancesVersions(force: false) { result in
            self.performSelector(onMainThread: #selector(SummaryViewController.checksFinished), with: self, waitUntilDone: true)
        }
    }
    
    /**
     Callback force check all instances.
     
     - Parameters:
     - sender: Sending object.
     */
    @objc public func forceCheckAllInstances(_ sender: AnyObject) {
        self.refreshActiveSpinner.isHidden = false
        self.refreshActiveSpinner.startAnimation(self)
        if let view = self.touchbarRefreshItem {
            (view.view as! NSButton).isEnabled = false
        }
        SummaryViewController.checkAllInstancesVersions(force: true) { result in
            self.performSelector(onMainThread: #selector(SummaryViewController.checksFinished), with: self, waitUntilDone: true)
        }
    }

    /**
     Checks all present version instances using GCD threading interface.

     - Parameters:
     - force: Passes the force attribute to instance models for ignoring check interval. Version strings will be fetched from instance webservice.
     - completionHandler: Called on thread termination.
     */
    public static func checkAllInstancesVersions(force: Bool, _ completionHandler: @escaping (Bool) -> ()) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            for instance in SystemInstances.systemInstances.keys {
                if ((SystemInstances.systemInstances[instance] as? JoomlaModel) != nil) {
                    let joomlamodel = SystemInstances.systemInstances[instance] as? JoomlaModel
                    //Remote Version url
                    _ = joomlamodel!.getVersions(forceUpdate: force)
                    _ = joomlamodel!.updateDate()
                    if (joomlamodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), joomlamodel!.name)))
                    }
                    _ = joomlamodel!.saveConfigfile()
                } else if ((SystemInstances.systemInstances[instance] as? PiwikModel) != nil) {
                    let piwikmodel = SystemInstances.systemInstances[instance] as? PiwikModel
                    //Remote Version url
                    _ = piwikmodel!.getVersions(forceUpdate: force)
                    _ = piwikmodel!.updateDate()
                    if (piwikmodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), piwikmodel!.name)))
                    }
                    _ = piwikmodel!.saveConfigfile()
                } else if ((SystemInstances.systemInstances[instance] as? OwncloudModel) != nil) {
                    let owncloudmodel = SystemInstances.systemInstances[instance] as? OwncloudModel
                    //Remote Version url
                    _ = owncloudmodel!.getVersions(forceUpdate: force)
                    _ = owncloudmodel!.updateDate()
                    if (owncloudmodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), owncloudmodel!.name)))
                    }
                    _ = owncloudmodel!.saveConfigfile()
                } else if ((SystemInstances.systemInstances[instance] as? WordpressModel) != nil) {
                    let wordpressmodel = SystemInstances.systemInstances[instance] as? WordpressModel
                    //Remote Version url
                    _ = wordpressmodel!.getVersions(forceUpdate: force)
                    _ = wordpressmodel!.updateDate()
                    if (wordpressmodel!.checkNotificationRequired()) {
                        sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), wordpressmodel!.name)))
                    }
                    _ = wordpressmodel!.saveConfigfile()
                }
            }
            completionHandler(true)
        }
    }
}

/**
 NSTouchBarDelegate extension for view controller.
 */
extension SummaryViewController: NSTouchBarDelegate {
    /**
     Generates a custom TouchBar.
     
     - Returns: Custom NSTouchBar.
     */
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .touchBarSummary
        touchBar.defaultItemIdentifiers = [.refreshAllInstances, .preferencesDialog, .flexibleSpace, .detailedViewController, .outdatedViewController]
        touchBar.customizationAllowedItemIdentifiers = [.refreshAllInstances, .preferencesDialog, .detailedViewController, .outdatedViewController]
        return touchBar
    }
    
    /**
     Creates SummaryViewController specific TouchBar buttons.
     
     - Parameters:
     - touchBar: TouchBar to be added to
     - identifier: NSTouchBarItem identifier.
     - Returns: NSTouchBarItem to be added to TouchBar, nil in case of failure.
     */
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItem.Identifier.preferencesDialog:
            self.touchbarPreferencesItem = NSCustomTouchBarItem(identifier: identifier)
            let preferencesButton = NSButton(image: NSImage(named: NSImage.actionTemplateName)!, target: self, action: #selector(GenericViewController.loadPreferencesWindow))
            self.touchbarPreferencesItem.view = preferencesButton
            return self.touchbarPreferencesItem
        case NSTouchBarItem.Identifier.refreshAllInstances:
            self.touchbarRefreshItem = NSCustomTouchBarItem(identifier: identifier)
            let refreshButton = NSButton(image: NSImage(named: NSImage.refreshTemplateName)!, target: self, action: #selector(SummaryViewController.checkAllInstances))
            self.touchbarRefreshItem.view = refreshButton
            return self.touchbarRefreshItem
        case NSTouchBarItem.Identifier.detailedViewController:
            self.detailedViewControllerItem = NSCustomTouchBarItem(identifier: identifier)
            let detailedButton = NSButton(image: NSImage(named: NSImage.Name("Detailed view.png"))!, target: self, action: #selector(GenericViewController.loadDetailedViewController))
            self.detailedViewControllerItem.view = detailedButton
            return self.detailedViewControllerItem
        case NSTouchBarItem.Identifier.outdatedViewController:
            self.outdatedViewControllerItem = NSCustomTouchBarItem(identifier: identifier)
            let outdatedButton = NSButton(image: NSImage(named: NSImage.Name("Outdated item.png"))!, target: self, action: #selector(GenericViewController.loadOutdatedViewController))
            self.outdatedViewControllerItem.view = outdatedButton
            return self.outdatedViewControllerItem
        default:
            return nil
        }
    }
}
