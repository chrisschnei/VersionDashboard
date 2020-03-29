//
//  ChartsController.swift
//  VersionDashboardiOS
//
//  Created by Christian Schneider on 11.03.18.
//  Copyright © 2018 NonameCompany. All rights reserved.
//

import UIKit
import Charts
#if targetEnvironment(simulator)
    import VersionDashboardSDK
#else
    import VersionDashboardSDKARM
#endif

class ChartsViewController: UIViewController {

    @IBOutlet weak var overviewChart: PieChartView!
    @IBOutlet weak var outdatedChart: PieChartView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Constants.initialize(Bundle.main.bundlePath)
        
        navigationBar.prefersLargeTitles = true
        
        if (HeadInstances.headInstances.count == 0) {
            if (!HeadInstancesModel.loadConfigfiles()) {
                print("Loading head instances models failed.")
            }
        }
        
        if (SystemInstances.systemInstances.count == 0) {
            if (!SystemInstancesModel.loadConfigfiles()) {
                print("Loading system instances models failed.")
            }
        }
        self.tabBarController?.setOutdatedBadgeNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.drawPieChartInstances()
        self.drawPieChartOutdated()
    }
    
    func drawPieChartInstances()
    {
        var chartdata = Array<PieChartDataEntry>()
        for (instancename, amount) in SystemInstancesModel.checkAllInstancesTypes() {
            chartdata.append(PieChartDataEntry(value: Double(amount), label:instancename))
        }
        
        let data = PieChartData()
        let ds1 = PieChartDataSet(entries: chartdata, label:"")
        ds1.colors = ChartColorTemplates.material()
        data.addDataSet(ds1)
        self.overviewChart.data = data
        self.overviewChart.chartDescription?.text = ""
    }
    
    func drawPieChartOutdated()
    {
        var chartdata = Array<PieChartDataEntry>()
        chartdata.append(PieChartDataEntry(value: Double(SystemInstancesModel.getAmountOfOutdateInstances()), label: NSLocalizedString("outdated", comment: "")))
        chartdata.append(PieChartDataEntry(value: Double(SystemInstancesModel.getAmountOfUptodateInstances()), label: NSLocalizedString("uptodate", comment: "")))
        
        let data = PieChartData()
        let ds1 = PieChartDataSet(entries: chartdata, label:"")
        ds1.colors = ChartColorTemplates.colorful()
        data.addDataSet(ds1)
        self.outdatedChart.data = data
        self.outdatedChart.chartDescription?.text = ""
    }
    
}
