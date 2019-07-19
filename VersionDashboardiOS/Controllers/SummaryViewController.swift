//
//  FirstViewController.swift
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

class SummaryViewController: GenericViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var refreshActiveSpinner: UIActivityIndicatorView!
    @IBOutlet weak var refreshAll: UIBarButtonItem!
    @IBOutlet weak var addInstance: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tabBarSummary: UITabBarItem!
    
    let cellReuseIdentifier = "instanceCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        table.delegate = self
        table.dataSource = self
        
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationController?.navigationItem.searchController = searchController
        self.navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationController?.navigationItem.titleView = navigationBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HeadInstancesModel.loadConfigfiles()
        SystemInstancesModel.loadConfigfiles()
        
        self.table.reloadData()
        
        self.tabBarController?.setOutdatedBadgeNumber()
    }
    
    @objc(tableView:leadingSwipeActionsConfigurationForRowAtIndexPath:) func tableView(_ tableView: UITableView,
                                                                                       leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let systemInstanceName = Array(SystemInstances.systemInstances.keys)[indexPath.row]
        _ = (Constants.plistFilesPath + systemInstanceName) + ".plist"
        let takeMeToMyInstanceAction = UIContextualAction(style: .normal, title: NSLocalizedString("takeMeToMyInstance", comment: ""), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if (self.takeMeToMyInstance(systemInstanceName)) {
                success(true)
            } else {
                success(false)
            }
            tableView.reloadData()
        })
        takeMeToMyInstanceAction.backgroundColor = .lightGray
        
        let refreshAction = UIContextualAction(style: .normal, title:  NSLocalizedString("refresh", comment: ""), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if (self.refreshInstance(instanceName: systemInstanceName)) {
                success(true)
            } else {
                success(false)
            }
        })
        refreshAction.backgroundColor = .darkGray
        
        return UISwipeActionsConfiguration(actions: [refreshAction, takeMeToMyInstanceAction])
    }
    
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row) \(indexPath.description).")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let detailsViewController = storyBoard.instantiateViewController(withIdentifier: "InstanceDetails") as! InstanceDetailsViewController
        detailsViewController.systemInstancesName = Array(SystemInstances.systemInstances.keys)[indexPath.row]
        self.present(detailsViewController, animated:true, completion:nil)
    }
    
    @objc(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:) func tableView(_ tableView: UITableView,
                                                                                        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let systemInstanceName = Array(SystemInstances.systemInstances.keys)[indexPath.row]
        let path = (Constants.plistFilesPath + systemInstanceName) + ".plist"
        let deleteAction = UIContextualAction(style: .normal, title: NSLocalizedString("deleteInstance", comment: ""), handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if (self.deleteInstance(path, systemInstanceName)) {
                success(true)
            } else {
                success(false)
            }
            tableView.reloadData()
        })
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = (self.table.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        let instance = SystemInstances.systemInstances[Array(SystemInstances.systemInstances.keys)[indexPath.row]]
        var name = ""
        if ((instance as? JoomlaModel) != nil) {
            cell.imageView?.image = UIImage(named: "joomla_dots.png")
            name = (instance as! JoomlaModel).name
        } else if ((instance as? WordpressModel) != nil) {
            cell.imageView?.image = UIImage(named: "wordpress_dots.png")
            name = (instance as! WordpressModel).name
        } else if ((instance as? PiwikModel) != nil) {
            cell.imageView?.image = UIImage(named: "piwik_dots.png")
            name = (instance as! PiwikModel).name
        } else {
            cell.imageView?.image = UIImage(named: "owncloud_dots.png")
            name = (instance as! OwncloudModel).name
        }
        cell.textLabel?.text = name
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SystemInstances.systemInstances.count
    }
    
    @IBAction func refreshAll(_ sender: Any) {
        self.refreshActiveSpinner.startAnimating()
        self.refreshActiveSpinner.isHidden = false
        SystemInstancesModel.checkAllInstancesVersions(force: false) { result in
            self.performSelector(onMainThread: #selector(self.checksFinished), with: self, waitUntilDone: true)
        }
    }
    
    func refreshInstance(instanceName: String) -> Bool {
        if(InternetConnectivity.checkInternetConnection()) {
            self.refreshActiveSpinner.startAnimating()
            self.refreshActiveSpinner.isHidden = false
            self.updateSingleInstance(instanceName: instanceName) { completion in
                let parameters = ["self": self, "completion" : completion] as [String : Any]
                self.performSelector(onMainThread: #selector(self.checksFinished), with: parameters, waitUntilDone: true)
            }
        }
        return true
    }
    
    @objc func checksFinished() -> Void {
        self.refreshActiveSpinner.stopAnimating()
        self.refreshActiveSpinner.isHidden = true
        SystemInstances.systemInstances.removeAll()
        SystemInstancesModel.loadConfigfiles()
        self.tabBarController?.setOutdatedBadgeNumber()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }

}
