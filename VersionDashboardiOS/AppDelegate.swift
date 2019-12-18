//
//  AppDelegate.swift
//  VersionDashboardiOS
//
//  Created by Christian Schneider on 02.09.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, shouldPresent notification: UNNotification) -> Bool {
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert]) {
            (granted, error) in
            print("Permission granted: \(granted)")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}
