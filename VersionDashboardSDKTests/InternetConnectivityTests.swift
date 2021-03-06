//
//  InternetConnectivityTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class InternetConnectivityTests: XCTestCase {

    override func setUp() {
       super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCheckInternetConnection() {
        XCTAssert(InternetConnectivity.checkInternetConnection())
    }

}
