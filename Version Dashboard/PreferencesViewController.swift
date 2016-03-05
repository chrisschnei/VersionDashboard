//
//  PreferencesViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.03.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {

    @IBOutlet weak var dropdownInterval: NSComboBox!
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var activatedCheckbox: NSButton!
    @IBOutlet weak var intervalTextLabel: NSTextField!
    @IBOutlet weak var activatedTextLabel: NSTextField!
    @IBOutlet weak var infoTextLabel: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConfigurationFile()
        self.setConfigurationValues()
    }
    
    func setConfigurationValues() {
        self.dropdownInterval.addItemsWithObjectValues(refreshIntervals)
        self.dropdownInterval.selectItemWithObjectValue(configurationSettings["interval"] as! String)
        self.activatedCheckbox.state = (configurationSettings["automaticRefreshActive"] as! Int)
    }
    
    func loadConfigurationFile() {
        var myDict: NSDictionary?
        if let path = configurationFilePath {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            configurationSettings["interval"] = dict["interval"]!
            configurationSettings["automaticRefreshActive"] = dict["automaticRefreshActive"]!
        }
    }
    
    func saveConfigurationFile() {
        if((Bool(self.activatedCheckbox.state) == true) && ((configurationSettings["automaticRefreshActive"] as! Bool) == false)) {
            PreferencesViewController().automaticRefresh()
        } else if(Bool(self.activatedCheckbox.state) == false) {
            PreferencesViewController().stopTimer()
        }
        
        configurationSettings["interval"] = self.dropdownInterval.selectedCell()?.stringValue
        configurationSettings["automaticRefreshActive"] = Bool(self.activatedCheckbox.state)
        
        let dict: NSMutableDictionary = NSMutableDictionary()
        dict.setObject(configurationSettings["interval"] as! String, forKey: "interval")
        dict.setObject(configurationSettings["automaticRefreshActive"] as! Bool, forKey: "automaticRefreshActive")
        
        let fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(configurationFilePath!)))
        {
            fileManager.createFileAtPath(configurationFilePath!, contents: nil, attributes: nil)
        }
        dict.writeToFile(configurationFilePath!, atomically: true)
    }
    
    @IBAction func savePreferences(sender: AnyObject) {
        self.saveConfigurationFile()
        self.dismissController(self)
    }
    
    @IBAction func cancelPreferences(sender: AnyObject) {
        self.dismissController(self)
    }
    
    func checkInstancesAutomatic() {
        SystemInstancesModel().checkAllInstancesVersions() { result in
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func automaticRefresh() {
        let seconds = (configurationSettings["interval"] as! Double)*(60.0*60.0)
        timer = NSTimer.scheduledTimerWithTimeInterval(seconds, target: self, selector: Selector("checkInstancesAutomatic"), userInfo: nil, repeats: true)
    }
}
