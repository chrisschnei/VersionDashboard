//
//  OwncloudInstanceUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class OwncloudInstanceUITests: XCTestCase, GenericTestInstanceProtocol {
    
    var owncloudtesturl = "https://test.de/"
    var owncloudtestinstancename = "Owncloudtestinstance"
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
        XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, owncloudtestinstancename)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/asana24.net\/piwik\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, owncloudtesturl)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"ok\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "OK")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["LastCheckLabel"]/*[[".staticTexts[\"29.10.2019, 17:33\"]",".staticTexts[\"LastCheckLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertEqual(versionDashboardWindow.staticTexts["CurrentVersionLabel"].value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["LatestVersionLabel"].value as! String, "")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["PhpVersionLabel"]/*[[".staticTexts[\"7.2.23\"]",".staticTexts[\"PhpVersionLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["WebserverLabel"]/*[[".staticTexts[\"Apache\/2.2.15 (CentOS)\"]",".staticTexts[\"WebserverLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["DownloadURL"].value as! String, "")
    }
    
    func createInstance() {
        versionDashboardWindow.toolbars.buttons["Detailed View"].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["AddInstanceButton"]/*[[".buttons[\"+\"]",".buttons[\"AddInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sheetsQuery = versionDashboardWindow.sheets
        sheetsQuery.buttons["OwncloudInstanceCreation"].click()
        
        let sheetsQuery2 = sheetsQuery.sheets
        sheetsQuery2/*@START_MENU_TOKEN@*/.textFields["OwncloudHostURL"]/*[[".textFields[\"http:\/\/example.com\/\"]",".textFields[\"OwncloudHostURL\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        versionDashboardWindow/*@START_MENU_TOKEN@*/.tables.cells.containing(.image, identifier:"owncloud dots").element/*[[".scrollViews.tables",".tableRows.cells.containing(.image, identifier:\"owncloud dots\").element",".cells.containing(.image, identifier:\"owncloud dots\").element",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.typeText("\(owncloudtesturl)\t\(owncloudtestinstancename)")
        sheetsQuery2/*@START_MENU_TOKEN@*/.buttons["OwncloudSave"]/*[[".buttons[\"Save\"]",".buttons[\"OwncloudSave\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        versionDashboardWindow.tables.staticTexts[owncloudtestinstancename].click()
    }
    
    func deleteInstance() {
        /* Delete testinstance */
        versionDashboardWindow.tables.staticTexts[owncloudtestinstancename].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RemoveInstanceButton"]/*[[".buttons[\"-\"]",".buttons[\"RemoveInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        /* Check if instance is deleted successfully */
        let cell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.staticText, identifier: owncloudtestinstancename)
        XCTAssertEqual(cell.textFields.count, 0)
    }
    
    func filterTestInstance() {
        let searchInstancesSearchField = versionDashboardWindow.searchFields["Search instances"]
        searchInstancesSearchField.click()
        
        searchInstancesSearchField.typeText(owncloudtestinstancename)
        
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.tables["InstanceTableView"]/*[[".scrollViews[\"InstanceScrollView\"].tables[\"InstanceTableView\"]",".tables[\"InstanceTableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .tableRow).element(boundBy: 0).cells.count, 1)
        
        let owncloudDotsCell = versionDashboardWindow/*@START_MENU_TOKEN@*/.tables["InstanceTableView"].cells.containing(.image, identifier:"owncloud dots").element/*[[".scrollViews[\"InstanceScrollView\"].tables[\"InstanceTableView\"]",".tableRows.cells.containing(.image, identifier:\"owncloud dots\").element",".cells.containing(.image, identifier:\"owncloud dots\").element",".tables[\"InstanceTableView\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        owncloudDotsCell.click()
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/test.de\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, owncloudtesturl)
        XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, owncloudtestinstancename)
        XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"OK\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "OK")
        XCTAssert(versionDashboardWindow.buttons["CopyDownloadURL"].isEnabled)
        XCTAssert(versionDashboardWindow.buttons["CopyDownloadURL"].isHittable)
        
        searchInstancesSearchField.buttons["cancel"].click()
    }
    
}
