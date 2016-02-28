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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.loadConfigfiles()
        self.initLabels()
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
    
    @IBAction func checkAllInstances(sender: AnyObject) {
    }
    
    func loadConfigfiles() {
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(appurl)!
        
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix("plist") {
                let myDict = NSDictionary(contentsOfFile: appurl.stringByAppendingString(element))
                if myDict!["type"] as! String == "Joomla" {
                    systemInstances[myDict!["name"] as! String] = JoomlaModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int)
                } else if myDict!["type"] as! String == "Wordpress" {
                    systemInstances[myDict!["name"] as! String] = WordpressModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int)
                } else if myDict!["type"] as! String == "Owncloud" {
                    systemInstances[myDict!["name"] as! String] = OwncloudModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int)
                } else if myDict!["type"] as! String == "Piwik" {
                    systemInstances[myDict!["name"] as! String] = PiwikModel(creationDate: myDict!["creationDate"] as! String, currentVersion: myDict!["currentVersion"] as! String, hosturl: myDict!["hosturl"] as! String, apiToken: myDict!["apiToken"] as! String, lastRefresh: myDict!["lastRefresh"] as! String, name: myDict!["name"] as! String, type: myDict!["type"] as! String, headVersion: myDict!["headVersion"] as! String, updateAvailable: myDict!["updateAvailable"] as! Int)
                }
                if((myDict!["updateAvailable"] as! Int) == 1) {
                    incrementBadgeNumber()
                }
            }
        }
    }

}
