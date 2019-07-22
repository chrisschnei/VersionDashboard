//
//  badgeFunctions.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 24.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation
import AppKit

func incrementBadgeNumber() {
    let doc = NSApplication.shared.dockTile
    if(doc.badgeLabel == nil || doc.badgeLabel == "") {
        doc.badgeLabel = "0"
    }
    let batchnumber = Int(doc.badgeLabel!)!
    doc.badgeLabel = String(batchnumber + 1)
}

func decrementBadgeNumber() {
    let doc = NSApplication.shared.dockTile
    let batchnumber = Int(doc.badgeLabel!)!
    if(batchnumber > 1) {
        doc.badgeLabel = String(batchnumber - 1)
    } else {
        doc.badgeLabel = ""
    }
}

func zeroBadgeNumber() {
    let doc = NSApplication.shared.dockTile
    doc.badgeLabel = ""
}
