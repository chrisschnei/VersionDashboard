//
//  OutdatedViewControllerUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class OutdatedViewControllerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testViewDidLoad() {
        let app = XCUIApplication()
        let versionDashboardWindow = app.windows["Version Dashboard"]
        versionDashboardWindow.toolbars.buttons["Outdated"].click()
        
        XCTAssert(versionDashboardWindow.buttons["RefreshButton"].isEnabled)
        XCTAssert(versionDashboardWindow.buttons["RefreshButton"].isHittable)
        XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as? String, "")
    }
    
}
