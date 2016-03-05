//
//  SummaryViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 27.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class SummaryViewController: NSViewController {

    @IBOutlet weak var checkAllInstancesButton: NSButton!
    @IBOutlet weak var phpVersions: NSTextField!
    @IBOutlet weak var amountInstancesOutofdate: NSTextField!
    @IBOutlet weak var amountInstancesUptodate: NSTextField!
    @IBOutlet weak var amountWordpressInstances: NSTextField!
    @IBOutlet weak var amountJoomlaInstances: NSTextField!
    @IBOutlet weak var amountPiwikInstances: NSTextField!
    @IBOutlet weak var amountOwncloudInstances: NSTextField!
    @IBOutlet weak var amountNoInstances: NSTextField!
    @IBOutlet weak var phpVersionsLabel: NSTextField!
    @IBOutlet weak var instancesOutofdateLabel: NSTextField!
    @IBOutlet weak var instancesUptodateLabel: NSTextField!
    @IBOutlet weak var wordpressInstancesLabel: NSTextField!
    @IBOutlet weak var joomlaInstancesLabel: NSTextField!
    @IBOutlet weak var piwikInstancesLabel: NSTextField!
    @IBOutlet weak var owncloudInstancesLabel: NSTextField!
    @IBOutlet weak var noOfInstancesLabel: NSTextField!
    @IBOutlet var summaryViewController: NSView!
    @IBOutlet weak var refreshActiveSpinner: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PreferencesViewController().loadConfigurationFile()
        SystemInstancesModel().loadConfigfiles()
        self.initLabels()
        if((configurationSettings["automaticRefreshActive"] as! Bool) == true) {
            PreferencesViewController().automaticRefresh()
        }
    }
    
    func initLabels() {
        let amount = SystemInstancesModel().getAmountOfInstances()
        self.amountNoInstances.stringValue = amount
        
        let instances = SystemInstancesModel().checkAllInstancesTypes()
        for type in instances.keys {
            if(type == "Wordpress") {
                self.amountWordpressInstances.stringValue = String(instances[type]!)
            } else if(type == "Joomla") {
                self.amountJoomlaInstances.stringValue = String(instances[type]!)
            } else if(type == "Piwik") {
                self.amountPiwikInstances.stringValue = String(instances[type]!)
            } else if(type == "Owncloud") {
                self.amountOwncloudInstances.stringValue = String(instances[type]!)
            }
        }
        
        //Todo Implement http header php version search
        self.phpVersions.stringValue = SystemInstancesModel().checkAllInstancesPHPVersions()
        
        self.amountInstancesOutofdate.stringValue = String(SystemInstancesModel().getAmountOfOutdateInstances())
        self.amountInstancesUptodate.stringValue = String(SystemInstancesModel().getAmountOfUptodateInstances())
    }
    
    func checksFinished() {
        self.refreshActiveSpinner.stopAnimation(self)
        self.refreshActiveSpinner.hidden = true
    }
    
    @IBAction func checkAllInstances(sender: AnyObject) {
        self.refreshActiveSpinner.hidden = false
        self.refreshActiveSpinner.startAnimation(self)
        SystemInstancesModel().checkAllInstancesVersions() { result in
            self.performSelectorOnMainThread("checksFinished", withObject: self, waitUntilDone: true)
        }
    }
}
