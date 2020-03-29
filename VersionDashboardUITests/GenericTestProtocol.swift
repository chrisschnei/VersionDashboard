//
//  GenericTestProtocol.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 29.03.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import Foundation

/**
 GenericTestProtocol.
 Implements mandatory functions for UI Tests.
 */
public protocol GenericTestProtocol {
    
    func testInstance()
    func checkInstanceDetails()
    func createInstance()
    func deleteInstance()
    func filterWordpressTestInstance()
}
