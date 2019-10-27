//
//  VersionDashboardXMLParserTests.swift
//  VersionDashboardSDKTests
//
//  Created by Christian Schneider on 24.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardSDK

class VersionDashboardXMLParserTests: XCTestCase {
    
    var parser: VersionDashboardXMLParser!

    override func setUp() {
        super.setUp()
        
        let queryurl = (Constants.joomlaAPIUrl + Constants.joomlapath)
        let pathToXml = URL(string: queryurl)
        parser = VersionDashboardXMLParser(url: pathToXml!)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testStartParsing() {
        XCTAssert(parser.startParsing())
    }

}
