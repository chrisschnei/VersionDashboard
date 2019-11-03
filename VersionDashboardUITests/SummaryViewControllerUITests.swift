//
//  SummaryViewControllerUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class SummaryViewControllerUITests: XCTestCase {
        
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
        versionDashboardWindow.toolbars.buttons["Summary"].click()
        XCTAssert(versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["CheckAllInstancesButton"]/*[[".buttons[\"Check all instances\"]",".buttons[\"CheckAllInstancesButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled)
        XCTAssert(versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["CheckAllInstancesButton"]/*[[".buttons[\"Check all instances\"]",".buttons[\"CheckAllInstancesButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isHittable)
    }
    
}
