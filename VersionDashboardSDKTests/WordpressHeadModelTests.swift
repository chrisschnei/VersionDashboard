//
//  WordpressHeadModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class WordpressHeadModelTests: XCTestCase {

    var testobject: WordpressHeadModel!
    
    override func setUp() {
        super.setUp()
        
        testobject = WordpressHeadModel(headVersion: "5.2.4", name: "Wordpress", type: "Wordpress", creationDate: Date(), lastRefresh: Date(), downloadurl: String())
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGetVersion() {
        XCTAssert(testobject.updateHeadObject(forceUpdate: true))
    }

}
