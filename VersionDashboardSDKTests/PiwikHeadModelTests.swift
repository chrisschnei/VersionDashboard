//
//  PiwikHeadModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class PiwikHeadModelTests: XCTestCase {

    var testobject: PiwikHeadModel!
    
    override func setUp() {
        super.setUp()
        
        testobject = PiwikHeadModel(headVersion: "3.11.0", name: "Piwik", type: "Piwik", creationDate: Date(), lastRefresh: Date(), downloadurl: String())
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetVersion() {
        XCTAssert(testobject.updateHeadObject(forceUpdate: true))
    }

}
