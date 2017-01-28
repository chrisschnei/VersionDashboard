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
        self.dropdownInterval.addItems(withObjectValues: refreshIntervals)
        self.dropdownInterval.selectItem(withObjectValue: configurationSettings["interval"] as! String)
        self.activatedCheckbox.state = Int((configurationSettings["automaticRefreshActive"] as! Bool) as NSNumber)
    }
    
    func loadConfigurationFile() {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: configurationFilePath) {
            do {
                try fileManager.createDirectory(atPath: applicationSupportAppNameURL, withIntermediateDirectories: true, attributes: nil)
                try fileManager.createDirectory(atPath: plistFilesPath, withIntermediateDirectories: true, attributes: nil)
                try fileManager.copyItem(atPath: appBundleConfigurationPath, toPath: configurationFilePath)
            }
            catch let error as NSError {
                NSLog("Error copying configuration.plist file to Application Support: \(error)")
            }
        }
        var myDict: NSDictionary?
        myDict = NSDictionary(contentsOfFile: configurationFilePath)
        if let dict = myDict {
            configurationSettings["interval"] = dict["interval"]! as AnyObject?
            configurationSettings["automaticRefreshActive"] = dict["automaticRefreshActive"]! as AnyObject?
        }
    }
    
    func saveConfigurationFile() {
        configurationSettings["interval"] = self.dropdownInterval.selectedCell()?.stringValue as AnyObject?
        configurationSettings["automaticRefreshActive"] = Bool((self.activatedCheckbox.state as AnyObject?)as! NSNumber)
        
        let dict: NSMutableDictionary = NSMutableDictionary()
        dict.setObject(configurationSettings["interval"] as! String, forKey: "interval" as NSCopying)
        dict.setObject(configurationSettings["automaticRefreshActive"] as! Bool, forKey: "automaticRefreshActive" as NSCopying)
        
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: configurationFilePath)))
        {
            fileManager.createFile(atPath: configurationFilePath, contents: nil, attributes: nil)
        }
        dict.write(toFile: configurationFilePath, atomically: true)
    }
    
    @IBAction func savePreferences(_ sender: AnyObject) {
        self.saveConfigurationFile()
        if(self.activatedCheckbox.state == 1) {
            self.stopTimer()
            self.automaticRefresh()
        } else if(self.activatedCheckbox.state == 0) {
            self.stopTimer()
        }
        self.dismiss(self)
    }
    
    @IBAction func cancelPreferences(_ sender: AnyObject) {
        self.dismiss(self)
    }
    
    func checkInstancesAutomatic() {
        if(checkInternetConnection()) {
            SystemInstancesModel().checkAllInstancesVersions() { result in
            }
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func automaticRefresh() {
        let seconds = Double(configurationSettings["interval"] as! String)!*(60.0*60.0)
        timer = Timer.scheduledTimer(timeInterval: seconds, target: self, selector: #selector(PreferencesViewController.checkInstancesAutomatic), userInfo: nil, repeats: true)
    }
}
