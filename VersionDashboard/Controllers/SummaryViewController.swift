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

class SummaryViewController: NSViewController {

    @IBOutlet weak var checkAllInstancesButton: NSButton!
    @IBOutlet var summaryViewController: NSView!
    @IBOutlet weak var refreshActiveSpinner: NSProgressIndicator!
    @IBOutlet weak var pieChartInstanceSummary: PieChartView!
    @IBOutlet weak var pieChartInstanceOutdated: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc func checksFinished() {
        self.refreshActiveSpinner.stopAnimation(self)
        self.refreshActiveSpinner.isHidden = true
        SystemInstances.systemInstances.removeAll()
        if (!SystemInstancesModel.loadConfigfiles()) {
            print("Loading system instances config files failed.")
        }
        self.drawPieChartInstances()
        self.drawPieChartOutdated()
        
        setOutdatedBadgeNumber()
    }
    
    @IBAction func checkAllInstances(_ sender: AnyObject) {
        self.refreshActiveSpinner.isHidden = false
        self.refreshActiveSpinner.startAnimation(self)
        SummaryViewController.checkAllInstancesVersions(force: false) { result in
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
