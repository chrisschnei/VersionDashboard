//
//  WordpressInstanceUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class WordpressInstanceUITests: XCTestCase, GenericTestInstanceProtocol {
    
    var wordpresstesturl = "https://test.de/"
    var wordpresstestinstancename = "Wordpresstestinstance"
    let versionDashboardWindow = XCUIApplication().windows["Version Dashboard"]
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        XCUIApplication().launch()
        self.createInstance()
    }
    
    override func tearDown() {
        self.deleteInstance()
        super.tearDown()
    }
    
    func testInstance() {
        self.checkInstanceDetails()
        self.filterTestInstance()
    }
    
    func checkInstanceDetails() {
        XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, wordpresstestinstancename)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/asana24.net\/piwik\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, wordpresstesturl)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"ok\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "OK")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["LastCheckLabel"]/*[[".staticTexts[\"29.10.2019, 17:33\"]",".staticTexts[\"LastCheckLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertEqual(versionDashboardWindow.staticTexts["CurrentVersionLabel"].value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["LatestVersionLabel"].value as! String, "")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["PhpVersionLabel"]/*[[".staticTexts[\"7.2.23\"]",".staticTexts[\"PhpVersionLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["WebserverLabel"]/*[[".staticTexts[\"Apache\/2.2.15 (CentOS)\"]",".staticTexts[\"WebserverLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
    }
    
    func createInstance() {
        versionDashboardWindow.toolbars.buttons["Detailed View"].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["AddInstanceButton"]/*[[".buttons[\"+\"]",".buttons[\"AddInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sheetsQuery = versionDashboardWindow.sheets
        sheetsQuery.buttons["WordpressInstanceCreation"].click()
        
        let sheetsQuery2 = sheetsQuery.sheets
        sheetsQuery2.textFields["WordpressHostURL"].click()
        
        versionDashboardWindow.tables.cells.containing(.image, identifier:"wordpress dots").element.typeText("\(wordpresstesturl)\t\(wordpresstestinstancename)")
        sheetsQuery2.buttons["WordpressSave"].click()
        versionDashboardWindow.tables.staticTexts[wordpresstestinstancename].click()
    }
    
    func deleteInstance() {
        /* Delete testinstance */
        versionDashboardWindow.tables.staticTexts[wordpresstestinstancename].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RemoveInstanceButton"]/*[[".buttons[\"-\"]",".buttons[\"RemoveInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        /* Check if instance is deleted successfully */
        let cell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.staticText, identifier: wordpresstestinstancename)
        XCTAssertEqual(cell.textFields.count, 0)
    }
    
    func filterTestInstance() {
        let searchInstancesSearchField = versionDashboardWindow.searchFields["Search instances"]
        searchInstancesSearchField.click()
        searchInstancesSearchField.typeText(wordpresstestinstancename)
        
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.tables["InstanceTableView"]/*[[".scrollViews[\"InstanceScrollView\"].tables[\"InstanceTableView\"]",".tables[\"InstanceTableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .tableRow).element(boundBy: 0).cells.count, 1)
        
        let wordpressDotsCell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.image, identifier:"wordpress dots").element
        wordpressDotsCell.click()
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/test.de\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, wordpresstesturl)
        XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, wordpresstestinstancename)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"OK\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "OK")
        
        searchInstancesSearchField.buttons["cancel"].click()
    }
    
}
