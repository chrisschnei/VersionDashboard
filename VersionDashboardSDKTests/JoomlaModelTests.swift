//
//  JoomlaModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class JoomlaModelTests: XCTestCase {
    
    var testobject: JoomlaModel!

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        testobject = JoomlaModel(creationDate: "03-04-2016", currentVersion: "3.9.12", hosturl: Constants.joomlaAPIUrl, headVersion: "3.9.12", lastRefresh: "25.10.2019, 19:53", name: "Testinstance", type: "Joomla", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetVersion() {
        XCTAssert(testobject.getVersions(forceUpdate: true))
    }
    
    func testGetInstanceVersion() {
        XCTAssertNotEqual(testobject.getInstanceVersion(Constants.joomlaAPIUrl + Constants.joomlapath), "")
    }

}
