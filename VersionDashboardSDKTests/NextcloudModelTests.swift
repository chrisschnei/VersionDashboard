//
//  NextcloudModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 02.05.21.
//  Copyright © 2021 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class NextcloudModelTests: XCTestCase {
    
    var testobject: NextcloudModel!
    
    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        testobject = NextcloudModel(creationDate: "06-04-2016", currentVersion: "10.3.0", hosturl: "https://demo2.nextcloud.com/", headVersion: "10.3", lastRefresh: "26.10.2019, 22:38", name: "Nextcloud", type: "Nextcloud", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetVersion() {
        XCTAssert(testobject.getVersions(forceUpdate: true))
        XCTAssertNotEqual((HeadInstances.headInstances["Nextcloud"] as! NextcloudHeadModel).downloadurl, "")
    }
    
}
