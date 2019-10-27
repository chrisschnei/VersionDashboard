//
//  OwncloudModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class OwncloudModelTests: XCTestCase {
    
    var testobject: OwncloudModel!

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        testobject = OwncloudModel(creationDate: "06-04-2016", currentVersion: "10.3.0", hosturl: "https://demo.owncloud.com/", headVersion: "10.3", lastRefresh: "26.10.2019, 22:38", name: "Owncloud", type: "Owncloud", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetVersion() {
        XCTAssert(testobject.getVersions(forceUpdate: true))
    }

}
