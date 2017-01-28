//
//  NotificationFunctions.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 28.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation
import Cocoa

func sendNotification(_ title: String, informativeText: String) {
    let notification = NSUserNotification()
    notification.title = title
    notification.informativeText = informativeText
    NSUserNotificationCenter.default.deliver(notification)
}
