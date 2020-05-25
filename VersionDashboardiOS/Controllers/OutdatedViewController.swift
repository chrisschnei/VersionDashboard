//
//  OutdatedViewController.swift
//  VersionDashboardiOS
//
//  Created by Christian Schneider on 02.09.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import UIKit
#if targetEnvironment(simulator)
import VersionDashboardSDK
#else
import VersionDashboardSDKARM
#endif

class OutdatedViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var refreshAllButton: UIBarButtonItem!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var outdatedNaviBar: UINavigationItem!
    
    var searchActive : Bool = false
    var genericview: GenericViewController
    
    let cellReuseIdentifier = "instanceCellOutdated"
    
    public init() {
        self.genericview = GenericViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.genericview = GenericViewController()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.rowHeight = 60.0
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.table.delegate = self
        self.table.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("searchInstances", comment: "")
        searchController.hidesNavigationBarDuringPresentation = false
        self.outdatedNaviBar.searchController = searchController
        self.outdatedNaviBar.hidesSearchBarWhenScrolling = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewWillAppear(_:)), name: NSNotification.Name(rawValue: "viewWillAppear"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshInstance(_:)), name: NSNotification.Name(rawValue: "refreshInstance"), object: nil)
    }
    
    @objc(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:) override func tableView(_ tableView: UITableView,
                                                                                       leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let systemInstanceName = Array(SystemInstancesModel.getOutdatedInstances().keys)[indexPath.row]
        return UISwipeActionsConfiguration(actions: self.genericview.createLeadingSwipeActions(systemInstanceName: systemInstanceName))
    }
    
    @objc(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:) override func tableView(_ tableView: UITableView,
                                                                                        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let systemInstanceName = Array(SystemInstances.systemInstances.keys)[indexPath.row]
        return UISwipeActionsConfiguration(actions: genericview.createTrailingSwipeActions(systemInstanceName: systemInstanceName))
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "InstanceDetails") as! InstanceDetailsViewController
        detailsViewController.systemInstancesName = Array(SystemInstancesModel.getOutdatedInstances().keys)[indexPath.row]
        self.present(detailsViewController, animated:true, completion:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (!HeadInstancesModel.loadConfigfiles()) {
            print("Loading head instances config files failed.")
        }
        if (!SystemInstancesModel.loadConfigfiles()) {
            print("Loading system instances config files failed.")
        }
        
        self.table.reloadData()
        
        self.tabBarController?.setOutdatedBadgeNumber()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SystemInstancesModel.getAmountOfOutdateInstances()
    }
    
    @objc func refreshInstance(_ notification: NSNotification) {
        if let dict = notification.userInfo as NSDictionary? {
            if let instancename = dict["systemInstanceName"] as? String {
                _ = self.refreshInstanceName(instanceName: instancename)
            }
        }
    }
    
    func refreshInstanceName(instanceName: String) -> Bool {
        if (InternetConnectivity.checkInternetConnection()) {
            self.refreshAllButton.isEnabled = false
            self.refreshControl?.beginRefreshing()
            self.genericview.updateSingleInstance(instanceName: instanceName) { completion in
                let parameters = ["self": self, "completion" : completion] as [String : Any]
                self.performSelector(onMainThread: #selector(self.checksFinished), with: parameters, waitUntilDone: true)
            }
        }
        return true
    }
    
    override func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let instance = SystemInstances.systemInstances[Array(SystemInstancesModel.getOutdatedInstances().keys)[indexPath.row]]
        return genericview.createCell(instance: instance!);
    }
    
    @IBAction func refreshAll(_ sender: Any) {
        self.refreshControl?.beginRefreshing()
        self.refreshAllButton.isEnabled = false
        SummaryViewController.checkAllInstancesVersions(force: false) { result in
            self.performSelector(onMainThread: #selector(self.checksFinished), with: self, waitUntilDone: true)
        }
    }
    
    @objc func checksFinished() -> Void {
        self.refreshControl?.endRefreshing()
        self.refreshAllButton.isEnabled = true
        SystemInstances.systemInstances.removeAll()
        if (!SystemInstancesModel.loadConfigfiles()) {
            print("Loading system instances config files failed.")
        }
        self.tabBarController?.setOutdatedBadgeNumber()
    }
}

extension OutdatedViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            genericview.filteredInstances = SystemInstancesModel.getOutdatedInstances()
        } else {
            genericview.filteredInstances = genericview.filteredInstances.filter { $0.key.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        self.table.reloadData()
    }
}
