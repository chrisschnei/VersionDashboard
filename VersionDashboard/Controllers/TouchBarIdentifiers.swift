//
//  TouchBarIdentifiers.swift
//  VersionDashboard
//
//  Created by Christian Schneider on 30.03.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import Cocoa

extension NSTouchBarItem.Identifier {
    static let summaryViewController = NSTouchBarItem.Identifier("com.versiondashboard.summaryViewController")
    static let detailedViewController = NSTouchBarItem.Identifier("com.versiondashboard.detailedViewController")
    static let outdatedViewController = NSTouchBarItem.Identifier("com.versiondashboard.outdatedViewController")
    static let refreshAllInstances = NSTouchBarItem.Identifier("com.versiondashboard.refreshAllInstances")
    static let preferencesDialog = NSTouchBarItem.Identifier("com.versiondashboard.preferencesDialog")
    static let addNewInstance = NSTouchBarItem.Identifier("com.versiondashboard.addNewInstance")
    static let removeInstance = NSTouchBarItem.Identifier("com.versiondashboard.removeInstance")
    static let openInstanceWebsite = NSTouchBarItem.Identifier("com.versiondashboard.openInstanceWebsite")
    static let editInstance = NSTouchBarItem.Identifier("com.versiondashboard.editInstance")
    static let refreshInstance = NSTouchBarItem.Identifier("com.versiondashboard.refreshInstance")
    static let owncloudInstanceTouchbar = NSTouchBarItem.Identifier("com.versiondashboard.owncloudInstance")
    static let wordpressInstanceTouchbar = NSTouchBarItem.Identifier("com.versiondashboard.wordpressInstance")
    static let joomlaInstanceTouchbar = NSTouchBarItem.Identifier("com.versiondashboard.joomlaInstance")
    static let piwikInstanceTouchbar = NSTouchBarItem.Identifier("com.versiondashboard.piwikInstance")
}

extension NSTouchBar.CustomizationIdentifier {
    static let touchBarSummary = "com.versiondashboard.touchBarSummary"
    static let touchBarDetailed = "com.versiondashboard.touchBarDetailed"
    static let touchBarOutdated = "com.versiondashboard.touchBarOutdated"
    static let touchBarAddInstance = "com.versiondashboard.touchBarAddInstance"
}
