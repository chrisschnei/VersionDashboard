//
//  PiwikModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class PiwikModelTests: XCTestCase {

    var testobject: PiwikModel!
    
    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        testobject = PiwikModel(creationDate: "06-04-2016", currentVersion: "3.11.0", hosturl: "https://piwik.demo.org/", apiToken: "1234567890", lastRefresh: "26.10.2019, 22:38", name: "Piwiktestinstance", type: "Piwik", headVersion: "10.3", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSaveConfigfile() {
        XCTAssert(testobject.saveConfigfile())
        XCTAssert(GenericModel.deleteFile(testobject.name))
    }

}
