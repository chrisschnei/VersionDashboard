//
//  JoomlaHeadModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class JoomlaHeadModelTests: XCTestCase {

    var testobject: JoomlaHeadModel!
    
    override func setUp() {
        super.setUp()
        
        testobject = JoomlaHeadModel(headVersion: "3.9.12", name: "Joomla", type: "Joomla", creationDate: Date(), lastRefresh: Date(), downloadurl: String())
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetVersion() {
        XCTAssert(testobject.updateHeadObject(forceUpdate: true))
    }
    
    func testGetInstanceVersion() {
        XCTAssertNotNil(testobject.getInstanceVersion(Constants.joomlaAPIUrl + Constants.joomlapath))
    }

}
