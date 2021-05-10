//
//  NextcloudHeadModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 02.05.21.
//  Copyright © 2021 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class NextcloudHeadModelTests: XCTestCase {
    
    var testobject: NextcloudHeadModel!
    
    override func setUp() {
        super.setUp()
        Constants.initialize(Bundle.main.bundlePath)
        
        testobject = NextcloudHeadModel(headVersion: "12.0.1", name: "Nextcloud", type: "Nextcloud", creationDate: Date(), lastRefresh: Date(), downloadurl: String())
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
