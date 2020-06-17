//
//  ChartsViewControllerUITests.swift
//  VersionDashboardiOSUITests
//
//  Created by Christian Schneider on 15.06.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import XCTest

class ChartsViewControllerUITests: XCTestCase {
    
    let overviewTabBarName = "Overview"
    let instancesTabBarName = "Instances"
    let outdatedTabBarName = "Outdated"

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
    }

    func testContent() {
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        
        XCTAssertEqual(tabBarsQuery.buttons.count, 3)
        XCTAssertNotNil(tabBarsQuery.buttons[overviewTabBarName])
        XCTAssertNotNil(tabBarsQuery.buttons[instancesTabBarName])
        XCTAssertNotNil(tabBarsQuery.buttons[outdatedTabBarName])
    }

}
