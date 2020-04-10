//
//  AppDelegate.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Cocoa
import VersionDashboardSDK

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var mainWindowController: MainWindow? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        NSUserNotificationCenter.default.delegate = self
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
    
    @IBAction func forceUpdateHeadVersion(_ sender: Any) {
        if (checkInternetConnection()) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "forceUpdateInstances"), object: nil)
//            SummaryViewController.checkAllInstancesVersions(force: true) { result in
//            }
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        mainWindowController?.window?.makeKeyAndOrderFront(self)
        return false
    }
}
