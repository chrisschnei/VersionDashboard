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

class SummaryViewController: NSViewController {

    @IBOutlet weak var checkAllInstancesButton: NSButton!
    @IBOutlet var summaryViewController: NSView!
    @IBOutlet weak var refreshActiveSpinner: NSProgressIndicator!
    @IBOutlet weak var pieChartInstanceSummary: PieChartView!
    @IBOutlet weak var pieChartInstanceOutdated: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PreferencesViewController().loadConfigurationFile()
        if(headInstances.count == 0) {
            HeadInstancesModel().loadConfigfiles()
        }
        if(systemInstances.count == 0) {
            SystemInstancesModel().loadConfigfiles()
        }
        if((configurationSettings["automaticRefreshActive"] as! Bool) == true) {
            PreferencesViewController().automaticRefresh()
        }
        self.drawPieChartInstances()
        self.drawPieChartOutdated()
    }
    
    func drawPieChartInstances() {
        var chartdata = Array<PieChartDataEntry>()
        for (instancename, amount) in SystemInstancesModel().checkAllInstancesTypes() {
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
        chartdata.append(PieChartDataEntry(value: Double(SystemInstancesModel().getAmountOfOutdateInstances()), label:"Outdated"))
        chartdata.append(PieChartDataEntry(value: Double(SystemInstancesModel().getAmountOfUptodateInstances()), label:"Up to Date"))
        
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
        systemInstances.removeAll()
        SystemInstancesModel().loadConfigfiles()
        self.drawPieChartInstances()
        self.drawPieChartOutdated()
    }
    
    @IBAction func checkAllInstances(_ sender: AnyObject) {
        self.refreshActiveSpinner.isHidden = false
        self.refreshActiveSpinner.startAnimation(self)
        SystemInstancesModel().checkAllInstancesVersions(force: false) { result in
            self.performSelector(onMainThread: #selector(SummaryViewController.checksFinished), with: self, waitUntilDone: true)
        }
    }
}
