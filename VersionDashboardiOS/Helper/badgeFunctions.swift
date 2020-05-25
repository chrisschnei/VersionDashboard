//
//  badgeFunctions.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 24.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation
import UIKit
#if targetEnvironment(simulator)
import VersionDashboardSDK
#else
import VersionDashboardSDKARM
#endif

extension UITabBarController {
    /* Badge functions for outdated item badge. */
    func setOutdatedBadgeNumber() {
        if (tabBar.items?[2] == nil) {
            print("Failed to unwrap tabBar item outdated. Cannot set badge value.")
            return
        }
        tabBarItem = tabBar.items![2]
        let outdatedAmount = SystemInstancesModel.getAmountOfOutdateInstances()
        if (outdatedAmount == 0) {
            tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        } else {
            tabBarItem.badgeValue = String(outdatedAmount)
            UIApplication.shared.applicationIconBadgeNumber = outdatedAmount
        }
    }
}
