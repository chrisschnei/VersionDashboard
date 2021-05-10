//
//  HeadInstancesTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class HeadInstancesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
    }

    override func tearDown() {
       super.tearDown()
    }

    func testHeadInstancesAmount() {
        /* VD currently supports 4 instance types */
        XCTAssertEqual(HeadInstances.headInstances.keys.count, 5)
        XCTAssertNotNil(HeadInstances.headInstances["Joomla"])
        XCTAssertNotNil(HeadInstances.headInstances["Wordpress"])
        XCTAssertNotNil(HeadInstances.headInstances["Piwik"])
        XCTAssertNotNil(HeadInstances.headInstances["Owncloud"])
        XCTAssertNotNil(HeadInstances.headInstances["Nextcloud"])
    }

}
