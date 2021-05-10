//
//  WordpressModelTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class WordpressModelTests: XCTestCase {

    var testobject: WordpressModel!
    
    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        testobject = WordpressModel(creationDate: "06-04-2016", currentVersion: "5.2.4", hosturl: "https://s1.demo.opensourcecms.com/wordpress/", headVersion: "5.2.4", lastRefresh: "26.10.2019, 22:38", name: "Wordpresstestinstance", type: "Wordpress", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSaveConfigfile() {
        XCTAssert(testobject.saveConfigfile())
        XCTAssert(GenericModel.deleteFile(testobject.name))
    }
    
    func testGetVersions() {
        XCTAssert(testobject.getVersions(forceUpdate: true))
    }
    
    func testCheckVersionViaJavascriptEmoji() {
        XCTAssertNotEqual(testobject.checkVersionViaJavascriptEmoji(), "")
    }
    
    func testCheckVersionViaRSSFeed() {
        XCTAssertNotEqual(testobject.checkVersionViaRSSFeed(), "")
    }

}
