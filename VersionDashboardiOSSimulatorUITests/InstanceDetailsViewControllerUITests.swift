//
//  InstancesViewControllerUITests.swift
//  VersionDashboardiOSSimulatorUITests
//
//  Created by Christian Schneider on 15.06.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import XCTest

class InstanceDetailsViewControllerUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testViewContent() {
        let app = XCUIApplication()
        app.tabBars.buttons["Summary"].tap()
        let table = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .table).element
        table.swipeDown()
        
        let instancesNavigationBar = app.navigationBars["Instances"]
        // Navigation buttons
        XCTAssert(instancesNavigationBar.buttons["Add"].isEnabled)
        XCTAssert(instancesNavigationBar.buttons["Add"].isHittable)
        XCTAssert(instancesNavigationBar.buttons["Refresh"].isEnabled)
        XCTAssert(instancesNavigationBar.buttons["Refresh"].isHittable)
        // Search bar
        XCTAssert(app.searchFields["Search Instances"].isHittable)
        XCTAssert(app.searchFields["Search Instances"].isEnabled)
        app.searchFields["Search Instances"].tap()
        XCTAssertFalse(app.searchFields["Search Instances"].isSelected)
        app.buttons["Cancel"].tap()
    }

}
