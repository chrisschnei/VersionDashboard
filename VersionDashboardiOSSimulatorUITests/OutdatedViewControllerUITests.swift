//
//  OutdatedViewControllerUITests.swift
//  VersionDashboardiOSSimulatorUITests
//
//  Created by Christian Schneider on 15.06.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import XCTest

class OutdatedViewControllerUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testViewContent() {
        let app = XCUIApplication()
        app.tabBars.buttons["Outdated"].tap()
        app.tables["Empty list"].swipeDown()
        
        let outdatedNavigationBar = app.navigationBars["Outdated"]
        XCTAssert(outdatedNavigationBar.buttons["Refresh"].isEnabled)
        XCTAssert(outdatedNavigationBar.buttons["Refresh"].isHittable)
        XCTAssert(app.searchFields["Search Instances"].isHittable)
        XCTAssert(app.searchFields["Search Instances"].isEnabled)
        app.searchFields["Search Instances"].tap()
        XCTAssertFalse(app.searchFields["Search Instances"].isSelected)
        app.buttons["Cancel"].tap()
    }

}
