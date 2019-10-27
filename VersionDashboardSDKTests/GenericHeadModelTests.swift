//
//  VersionDashboardSDKTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class GenericHeadModelTests: XCTestCase {
    
    var testobject: GenericHeadModel!
    
    let instancename = String("Testheadmodel.plist")

    override func setUp() {
        super.setUp()
        
        testobject = GenericHeadModel(headVersion: "3.9.12", name: instancename, type: "Joomla", creationDate: Date(), lastRefresh: Date())
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testGetVersions() {
        XCTAssertFalse(testobject.getVersion(forceUpdate: false))
    }
    
    func testUpdateDate() {
        let current = testobject.lastRefresh
        testobject.updateDate()
        
        XCTAssertLessThan(current, testobject.lastRefresh)
    }

    func testSaveConfigfile() {
        XCTAssert(testobject.saveConfigfile(filename: instancename))
    }
    
    func testRenamePlistFiles() {
        XCTAssert(testobject.renamePlistFile(instancename))
    }
    
    func testDeleteFile() {
        XCTAssert(GenericHeadModel.deleteFile(instancename))
    }

}
