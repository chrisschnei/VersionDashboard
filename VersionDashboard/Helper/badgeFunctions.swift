//
//  badgeFunctions.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 24.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation
import AppKit
import VersionDashboardSDK

/**
 Sets app icons badge number showing amount of outdated instances.
 */
func setOutdatedBadgeNumber() {
    let doc = NSApplication.shared.dockTile
    let outdatedAmount = SystemInstancesModel.getAmountOfOutdateInstances()
    
    if(doc.badgeLabel == nil || doc.badgeLabel == "" || outdatedAmount == 0) {
        doc.badgeLabel = ""
        return
    }
    doc.badgeLabel = String(outdatedAmount)
}

/**
 Sets app icons badge number to zero.
 */
func zeroBadgeNumber() {
    let doc = NSApplication.shared.dockTile
    doc.badgeLabel = ""
}
