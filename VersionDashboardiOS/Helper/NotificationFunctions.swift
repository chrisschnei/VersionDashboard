//
//  NotificationFunctions.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 28.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation
import UserNotifications

func sendNotification(heading: String, informativeText: String) {
    let content = UNMutableNotificationContent()
    content.title = NSString.localizedUserNotificationString(forKey: heading, arguments: nil)
    content.body = NSString.localizedUserNotificationString(forKey: informativeText, arguments: nil)
    let time = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let request = UNNotificationRequest(identifier: "OutdatedInstance", content: content, trigger: time)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
