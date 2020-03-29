//
//  PiwikInstanceUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class PiwikInstanceUITests: XCTestCase, GenericTestInstanceProtocol {
    
    var piwiktesturl = "https://test.de/"
    var piwiktestinstancename = "Piwiktestinstance"
    var piwiktestapikey = "1234567890"
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
    
    func createInstance() {
        versionDashboardWindow.toolbars.buttons["Detailed View"].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["AddInstanceButton"]/*[[".buttons[\"+\"]",".buttons[\"AddInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sheetsQuery = versionDashboardWindow.sheets
        sheetsQuery.buttons["PiwikInstanceCreation"].click()
        
        let sheetsQuery2 = sheetsQuery.sheets
        sheetsQuery2.textFields["PiwikHostURL"].click()
        
        versionDashboardWindow.tables.cells.containing(.image, identifier:"joomla dots").element.typeText("\(piwiktesturl)\t\(piwiktestapikey)\t\(piwiktestinstancename)")
        sheetsQuery2.buttons["PiwikSave"].click()
        versionDashboardWindow.tables.staticTexts[piwiktestinstancename].click()
    }
    
    func checkInstanceDetails() {
        XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, piwiktestinstancename)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/asana24.net\/piwik\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, piwiktesturl)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"ok\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "OK")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["LastCheckLabel"]/*[[".staticTexts[\"29.10.2019, 17:33\"]",".staticTexts[\"LastCheckLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertEqual(versionDashboardWindow.staticTexts["CurrentVersionLabel"].value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["LatestVersionLabel"].value as! String, "")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["PhpVersionLabel"]/*[[".staticTexts[\"7.2.23\"]",".staticTexts[\"PhpVersionLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["WebserverLabel"]/*[[".staticTexts[\"Apache\/2.2.15 (CentOS)\"]",".staticTexts[\"WebserverLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
    }
    
    func deleteInstance() {
        versionDashboardWindow.tables.staticTexts[piwiktestinstancename].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RemoveInstanceButton"]/*[[".buttons[\"-\"]",".buttons[\"RemoveInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        /* Check if instance is deleted successfully */
        let cell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.staticText, identifier: piwiktestinstancename)
        XCTAssertEqual(cell.textFields.count, 0)
    }
    
    func filterTestInstance() {
        let searchInstancesSearchField = versionDashboardWindow.searchFields["Search instances"]
        searchInstancesSearchField.click()
        
        searchInstancesSearchField.typeText(piwiktestinstancename)
        
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.tables["InstanceTableView"]/*[[".scrollViews[\"InstanceScrollView\"].tables[\"InstanceTableView\"]",".tables[\"InstanceTableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .tableRow).element(boundBy: 0).cells.count, 1)
        
        let piwikDotsCell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.image, identifier:"piwik dots").element
        piwikDotsCell.click()
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/test.de\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, piwiktesturl)
        XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, piwiktestinstancename)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"OK\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "OK")
        
        searchInstancesSearchField.buttons["cancel"].click()
    }
    
}
