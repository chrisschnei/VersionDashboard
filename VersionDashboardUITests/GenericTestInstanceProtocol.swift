//
//  GenericTestInstanceProtocol.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 29.03.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import Foundation

/**
 GenericTestInstanceProtocol.
 Implements mandatory functions for UI Tests.
 */
public protocol GenericTestInstanceProtocol {
    
    /**
     Entry point for instance tests.
     */
    func testInstance()
    
    /**
     Check displayed instance details.
     */
    func checkInstanceDetails()
    
    /**
     Create testinstance. Call this in setup() function after application launch.
     */
    func createInstance()
    
    /**
     Delete newly created testinstance. Call this in teardown() function.
     */
    func deleteInstance()
    
    /**
     Test search bar.
     */
    func filterTestInstance()
}
