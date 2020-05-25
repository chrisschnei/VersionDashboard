//
//  SummaryViewController.swift
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

class SummaryViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var addInstanceRight: UIBarButtonItem!
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var instancesNaviBar: UINavigationItem!
    
    var genericview: GenericViewController
    
    let cellReuseIdentifier = "instanceCell"
    
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
        
        genericview.filteredInstances = SystemInstances.systemInstances
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self as UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("searchInstances", comment: "")
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        self.instancesNaviBar.searchController = searchController
        self.instancesNaviBar.hidesSearchBarWhenScrolling = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewWillAppear(_:)), name: NSNotification.Name(rawValue: "viewWillAppear"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshInstance(_:)), name: NSNotification.Name(rawValue: "refreshInstance"), object: nil)
    }
    
    @IBAction func refreshControlAction(_ sender: Any) {
        self.refreshButton.isEnabled = false
        SummaryViewController.checkAllInstancesVersions(force: false) { result in
            self.performSelector(onMainThread: #selector(self.checksFinished), with: self, waitUntilDone: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if (!HeadInstancesModel.loadConfigfiles()) {
            print("Loading head instances config files failed.")
        }
        if (!SystemInstancesModel.loadConfigfiles()) {
            print("Loading system instances config files failed.")
        }
        let searchText = self.instancesNaviBar.searchController?.searchBar.text!
        if (searchText == "") {
            genericview.filteredInstances = SystemInstances.systemInstances
        } else {
            genericview.filteredInstances = genericview.filteredInstances.filter { $0.key.lowercased().contains(searchText!.lowercased()) }
        }
        
        self.table.reloadData()
        self.tabBarController?.setOutdatedBadgeNumber()
    }
    
    @objc(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:) override func tableView(_ tableView: UITableView,
                                                                                       leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let systemInstanceName = Array(genericview.filteredInstances.keys)[indexPath.row]
        return UISwipeActionsConfiguration(actions: self.genericview.createLeadingSwipeActions(systemInstanceName: systemInstanceName))
    }
    
    @objc(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:) override func tableView(_ tableView: UITableView,
                                                                                                 trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let systemInstanceName = Array(genericview.filteredInstances.keys)[indexPath.row]
        return UISwipeActionsConfiguration(actions: genericview.createTrailingSwipeActions(systemInstanceName: systemInstanceName))
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "InstanceDetailsViewController") as! InstanceDetailsViewController
        detailsViewController.systemInstancesName = Array(genericview.filteredInstances.keys)[indexPath.row]
        self.present(detailsViewController, animated:true, completion:nil)
    }
    
    override func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let instance = genericview.filteredInstances[Array(genericview.filteredInstances.keys)[indexPath.row]]
        return genericview.createCell(instance: instance!);
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genericview.filteredInstances.count
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
                    _ = joomlamodel!.getVersions(forceUpdate: force)
                    _ = joomlamodel!.updateDate()
                    if (joomlamodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), joomlamodel!.name)))
                    }
                    _ = joomlamodel!.saveConfigfile()
                } else if ((SystemInstances.systemInstances[instance] as? PiwikModel) != nil) {
                    let piwikmodel = SystemInstances.systemInstances[instance] as? PiwikModel
                    _ = piwikmodel!.getVersions(forceUpdate: force)
                    _ = piwikmodel!.updateDate()
                    if (piwikmodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), piwikmodel!.name)))
                    }
                    _ = piwikmodel!.saveConfigfile()
                } else if ((SystemInstances.systemInstances[instance] as? OwncloudModel) != nil) {
                    let owncloudmodel = SystemInstances.systemInstances[instance] as? OwncloudModel
                    _ = owncloudmodel!.getVersions(forceUpdate: force)
                    _ = owncloudmodel!.updateDate()
                    if (owncloudmodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), owncloudmodel!.name)))
                    }
                    _ = owncloudmodel!.saveConfigfile()
                } else if ((SystemInstances.systemInstances[instance] as? WordpressModel) != nil) {
                    let wordpressmodel = SystemInstances.systemInstances[instance] as? WordpressModel
                    _ = wordpressmodel!.getVersions(forceUpdate: force)
                    _ = wordpressmodel!.updateDate()
                    if (wordpressmodel!.checkNotificationRequired()) {
                        sendNotification(heading: NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), wordpressmodel!.name)))
                    }
                    _ = wordpressmodel!.saveConfigfile()
                }
            }
            completionHandler(true)
        }
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
            self.refreshButton.isEnabled = false
            self.refreshControl?.beginRefreshing()
            self.genericview.updateSingleInstance(instanceName: instanceName) { completion in
                let parameters = ["self": self, "completion" : completion] as [String : Any]
                self.performSelector(onMainThread: #selector(self.checksFinished), with: parameters, waitUntilDone: true)
            }
        }
        return true
    }
    
    @objc func checksFinished() -> Void {
        self.refreshControl?.endRefreshing()
        self.refreshButton.isEnabled = true
        SystemInstances.systemInstances.removeAll()
        if (!SystemInstancesModel.loadConfigfiles()) {
            print("Loading system instances config files failed.")
        }
        self.tabBarController?.setOutdatedBadgeNumber()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension SummaryViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            genericview.filteredInstances = SystemInstances.systemInstances
        } else {
            genericview.filteredInstances = genericview.filteredInstances.filter { $0.key.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        self.table.reloadData()
    }
}
