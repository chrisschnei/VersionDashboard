//
//  SystemInstancesModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class SystemInstancesModelTests: XCTestCase {
    
    var testobject: SystemInstancesModel!

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        XCTAssert(SystemInstancesModel.loadConfigfiles())
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testGetAmountOfOutdatedInstances() {
        XCTAssertEqual(SystemInstancesModel.getAmountOfOutdateInstances(), 0)
    }

}
