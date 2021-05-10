//
//  NextcloudInstanceUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 02.05.21.
//  Copyright © 2021 NonameCompany. All rights reserved.
//

import XCTest

class NextcloudInstanceUITests: XCTestCase, GenericTestInstanceProtocol {
    
        var nextcloudtesturl = "https://test.de/"
        var nextcloudtestinstancename = "Nextcloudtestinstance"
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
            XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, nextcloudtestinstancename)
            XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/asana24.net\/piwik\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, nextcloudtesturl)
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
            sheetsQuery.buttons["NextcloudInstanceCreation"].click()
            
            let sheetsQuery2 = sheetsQuery.sheets
            sheetsQuery2.textFields["NextcloudHostURL"].click()
            
            versionDashboardWindow.tables.cells.containing(.image, identifier:"nextcloud dots").element.typeText("\(nextcloudtesturl)\t\(nextcloudtestinstancename)")
            sheetsQuery2.buttons["NextcloudSave"].click()
            versionDashboardWindow.tables.staticTexts[nextcloudtestinstancename].click()
        }
        
        func deleteInstance() {
            /* Delete testinstance */
            versionDashboardWindow.tables.staticTexts[nextcloudtestinstancename].click()
            versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RemoveInstanceButton"]/*[[".buttons[\"-\"]",".buttons[\"RemoveInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
            
            /* Check if instance is deleted successfully */
            let cell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.staticText, identifier: nextcloudtestinstancename)
            XCTAssertEqual(cell.textFields.count, 0)
        }
        
        func filterTestInstance() {
            let searchInstancesSearchField = versionDashboardWindow.searchFields["Search instances"]
            searchInstancesSearchField.click()
            
            searchInstancesSearchField.typeText(nextcloudtestinstancename)
            
            XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.tables["InstanceTableView"]/*[[".scrollViews[\"InstanceScrollView\"].tables[\"InstanceTableView\"]",".tables[\"InstanceTableView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .tableRow).element(boundBy: 0).cells.count, 1)
            
            let nextcloudDotsCell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.image, identifier:"nextcloud dots").element
            nextcloudDotsCell.click()
            XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/test.de\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, nextcloudtesturl)
            XCTAssertEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, nextcloudtestinstancename)
            XCTAssertEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"OK\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "OK")
            XCTAssert(versionDashboardWindow.buttons["CopyDownloadURL"].isEnabled)
            XCTAssert(versionDashboardWindow.buttons["CopyDownloadURL"].isHittable)
            
            searchInstancesSearchField.buttons["cancel"].click()
        }
        
    }
