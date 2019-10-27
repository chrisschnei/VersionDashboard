//
//  GenericModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class GenericModelTests: XCTestCase {
    
    var testobject: GenericModel!
    
    let instancename = String("Testinstance")

    override func setUp() {
        super.setUp()
        
        testobject = GenericModel(creationDate: "03-04-2016", currentVersion: "3.9.12", hosturl: "https://test.de", headVersion: "3.9.12", lastRefresh: "25.10.2019, 19:53", name: instancename, type: "Joomla", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetVersions() {
        XCTAssertFalse(testobject.getVersions(forceUpdate: false))
    }
    
    func testCheckNotificationRequired() {
        testobject.checkNotificationRequired()
        XCTAssertEqual(testobject.updateAvailable, 0)
    }
    
    func testUpdateDate() {
        let current = testobject.lastRefresh
        testobject.updateDate()
        
        XCTAssertLessThan(current, testobject.lastRefresh)
    }
    
    func testSaveConfigfile() {
        XCTAssert(testobject.saveConfigfile())
    }
    
    func testRenamePlistFiles() {
        XCTAssert(testobject.renamePlistFile(instancename))
    }
    
    func testDeleteFile() {
        XCTAssert(GenericModel.deleteFile(instancename))
    }

}
