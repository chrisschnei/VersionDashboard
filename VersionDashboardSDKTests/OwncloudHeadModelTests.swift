//
//  OwncloudHeadModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class OwncloudHeadModelTests: XCTestCase {
    
    var testobject: OwncloudHeadModel!

    override func setUp() {
        super.setUp()
        Constants.initialize(Bundle.main.bundlePath)
        
        testobject = OwncloudHeadModel(headVersion: "10.3", name: "Owncloud", type: "Owncloud", creationDate: Date(), lastRefresh: Date(), downloadurl: String())
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetVersion() {
        XCTAssertTrue(testobject.updateHeadObject(forceUpdate: true))
        XCTAssertNotEqual(testobject.headVersion, "")
        XCTAssertNotEqual(testobject.downloadurl, "")
    }

}
