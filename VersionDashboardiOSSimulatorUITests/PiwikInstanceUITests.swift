//
//  PiwikInstanceUITests.swift
//  VersionDashboardiOSSimulatorUITests
//
//  Created by Christian Schneider on 15.06.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import XCTest

class PiwikInstanceUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        self.deleteTestinstance()
    }
    
    func testInstanceCreation() {
        let app = XCUIApplication()
        // Open add piwik view controller
        app.tabBars.buttons["Summary"].tap()
        app.navigationBars["Instances"].buttons["Add"].tap()
        app.buttons["Piwik instance type"].tap()
        
        // Fill in Piwik instance details
        app.textFields["Instance name"].tap()
        app.textFields["Instance name"].typeText("Testinstance")
        app.textFields["Host url"].tap()
        app.textFields["Host url"].typeText("https://test.de/")
        app.textFields["Api token"].tap()
        app.textFields["Api token"].typeText("1234567890")
        app.navigationBars["Piwik instance"].buttons["Save"].tap()
        
        // Open newly created Piwik instance
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Testinstance"]/*[[".cells.staticTexts[\"Testinstance\"]",".staticTexts[\"Testinstance\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertEqual(app.textFields["Instance title"].value as? String, "Testinstance")
        XCTAssertEqual(app.textFields["Host URL"].value as? String, "https://test.de/")
        
        app.navigationBars["Instance details"].buttons["Cancel"].tap()
    }
    
    func deleteTestinstance() {
        let app = XCUIApplication()
        app.tabBars.buttons["Summary"].tap()
        
        let testinstanceStaticText = app.tables/*@START_MENU_TOKEN@*/.staticTexts["Testinstance"]/*[[".cells.staticTexts[\"Testinstance\"]",".staticTexts[\"Testinstance\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        testinstanceStaticText.swipeLeft()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["trash"].tap()
    }

}
