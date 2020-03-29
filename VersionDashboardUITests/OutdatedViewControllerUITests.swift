//
//  OutdatedViewControllerUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class OutdatedViewControllerUITests: XCTestCase {
    
    let versionDashboardWindow = XCUIApplication().windows["Version Dashboard"]
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewDidLoad() {
        versionDashboardWindow.toolbars.buttons["Outdated"].click()
        
        XCTAssertFalse(versionDashboardWindow.buttons["RefreshButton"].isEnabled)
        XCTAssertEqual(versionDashboardWindow.tables["InstanceTableView"].textFields.count, 0)
    }
}
