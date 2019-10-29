//
//  PreferencesViewController.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.03.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

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
        self.dropdownInterval.addItems(withObjectValues: Constants.refreshIntervals)
        self.dropdownInterval.selectItem(withObjectValue: ConfigurationSettings.configurationSettings["interval"] as! String)
        self.activatedCheckbox.state = NSControl.StateValue(rawValue: ConfigurationSettings.configurationSettings["automaticRefreshActive"] as! Int)
    }
    
    func loadConfigurationFile() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: Constants.configurationFilePath) {
            do {
                try fileManager.createDirectory(atPath: Constants.plistFilesPath, withIntermediateDirectories: true, attributes: nil)
                try fileManager.copyItem(atPath: Constants.appBundleConfigationPath, toPath: Constants.configurationFilePath)
            }
            catch let error as NSError {
                NSLog("Error copying configuration.plist file to Application Support: \(error)")
            }
        }
        var myDict: NSDictionary?
        myDict = NSDictionary(contentsOfFile: Constants.configurationFilePath)
        if let dict = myDict {
            ConfigurationSettings.configurationSettings["interval"] = dict["interval"]! as AnyObject?
            ConfigurationSettings.configurationSettings["automaticRefreshActive"] = dict["automaticRefreshActive"]! as AnyObject?
        }
    }
    
    func saveConfigurationFile() -> Bool {
        ConfigurationSettings.configurationSettings["interval"] = self.dropdownInterval.selectedCell()?.stringValue as AnyObject?
        ConfigurationSettings.configurationSettings["automaticRefreshActive"] = Bool(truncating: (self.activatedCheckbox.state as AnyObject?)as! NSNumber)
        
        let dict: NSMutableDictionary = NSMutableDictionary()
        dict.setObject(ConfigurationSettings.configurationSettings["interval"] as! String, forKey: "interval" as NSCopying)
        dict.setObject(ConfigurationSettings.configurationSettings["automaticRefreshActive"] as! Bool, forKey: "automaticRefreshActive" as NSCopying)
        
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: Constants.configurationFilePath)))
        {
            fileManager.createFile(atPath: Constants.configurationFilePath, contents: nil, attributes: nil)
        }
        return dict.write(toFile: Constants.configurationFilePath, atomically: true)
    }
    
    @IBAction func savePreferences(_ sender: AnyObject) {
        if (!self.saveConfigurationFile()) {
            print("Saving configuration file failed.")
        }
        if(self.activatedCheckbox.state.rawValue == 1) {
            self.stopTimer()
            self.automaticRefresh()
        } else if(self.activatedCheckbox.state.rawValue == 0) {
            self.stopTimer()
        }
        self.dismiss(self)
    }
    
    @IBAction func cancelPreferences(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    @objc func checkInstancesAutomatic() {
        if(checkInternetConnection()) {
            SystemInstancesModel.checkAllInstancesVersions(force: false) { result in
            }
        }
    }
    
    func stopTimer() {
        Constants.timer.invalidate()
    }
    
    func automaticRefresh() {
        let seconds = Double(ConfigurationSettings.configurationSettings["interval"] as! String)!*(60.0*60.0)
        Constants.timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(PreferencesViewController.checkInstancesAutomatic), userInfo: nil, repeats: true)
    }
}
