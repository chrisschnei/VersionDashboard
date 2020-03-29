//
//  SettingsViewControllerUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class SettingsViewControllerUITests: XCTestCase {
    
    var wordpresstesturl = "https://test.de/"
    var wordpresstestinstancename = "Wordpresstestinstance"
    
    var piwiktesturl = "https://test.de/"
    var piwiktestinstancename = "Piwiktestinstance"
    var piwiktestapikey = "1234567890"
    
    let versionDashboardWindow = XCUIApplication().windows["Version Dashboard"]
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInstances() {
        self.editWordpressInstance()
        self.editPiwikInstance()
    }
    
    func createWordpressTestinstance() {
        versionDashboardWindow.toolbars.buttons["Detailed View"].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["AddInstanceButton"]/*[[".buttons[\"+\"]",".buttons[\"AddInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sheetsQuery = versionDashboardWindow.sheets
        sheetsQuery.buttons["WordpressInstanceCreation"].click()
        
        let sheetsQuery2 = sheetsQuery.sheets
        sheetsQuery2.textFields["WordpressHostURL"].click()
        
        sheetsQuery2.textFields["WordpressHostURL"].typeText("\(wordpresstesturl)\t\(wordpresstestinstancename)")
        sheetsQuery2.buttons["WordpressSave"].click()
        versionDashboardWindow.tables.staticTexts[wordpresstestinstancename].click()
    }
    
    func deleteWordpressTestinstance() {
        versionDashboardWindow.tables.staticTexts[wordpresstestinstancename].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RemoveInstanceButton"]/*[[".buttons[\"-\"]",".buttons[\"RemoveInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let cell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.staticText, identifier: wordpresstestinstancename)
        XCTAssertEqual(cell.textFields.count, 0)
    }
    
    func editWordpressInstance() {
        self.createWordpressTestinstance()
        
        versionDashboardWindow.tables["InstanceTableView"].staticTexts[wordpresstestinstancename].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["EditInstanceButton"]/*[[".buttons[\"Edit\"]",".buttons[\"EditInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sheetsQueryEdit = versionDashboardWindow.sheets
        XCTAssertEqual(sheetsQueryEdit.textFields["EditInstanceSystemname"].value as! String, wordpresstestinstancename)
        XCTAssertEqual(sheetsQueryEdit/*@START_MENU_TOKEN@*/.textFields["EditInstanceHost"]/*[[".textFields[\"http:\/\/example.com\/\"]",".textFields[\"EditInstanceHost\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, wordpresstesturl)
        XCTAssertEqual(sheetsQueryEdit/*@START_MENU_TOKEN@*/.staticTexts["EditInstanceLastCheck"]/*[[".staticTexts[\"29.10.2019, 17:33\"]",".staticTexts[\"EditInstanceLastCheck\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        versionDashboardWindow.sheets/*@START_MENU_TOKEN@*/.buttons["EditInstanceSave"]/*[[".buttons[\"Save\"]",".buttons[\"EditInstanceSave\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        self.deleteWordpressTestinstance()
    }
    
    func createPiwikTestinstance() {
        versionDashboardWindow.toolbars.buttons["Detailed View"].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["AddInstanceButton"]/*[[".buttons[\"+\"]",".buttons[\"AddInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sheetsQuery = versionDashboardWindow.sheets
        sheetsQuery.buttons["PiwikInstanceCreation"].click()
        
        let sheetsQuery2 = sheetsQuery.sheets
        sheetsQuery2.textFields["PiwikHostURL"].click()
        
        sheetsQuery2.textFields["PiwikHostURL"].typeText("\(piwiktesturl)\t\(piwiktestapikey)\t\(piwiktestinstancename)")
        sheetsQuery2.buttons["PiwikSave"].click()
        versionDashboardWindow.tables.staticTexts[piwiktestinstancename].click()
    }
    
    func editPiwikInstance() {
        self.createPiwikTestinstance()
        
        versionDashboardWindow.tables["InstanceTableView"].staticTexts[piwiktestinstancename].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["EditInstanceButton"]/*[[".buttons[\"Edit\"]",".buttons[\"EditInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let sheetsQueryEdit = versionDashboardWindow.sheets
        XCTAssertEqual(sheetsQueryEdit.textFields["EditInstanceSystemname"].value as! String, piwiktestinstancename)
        XCTAssertEqual(sheetsQueryEdit/*@START_MENU_TOKEN@*/.textFields["EditInstanceHost"]/*[[".textFields[\"http:\/\/example.com\/\"]",".textFields[\"EditInstanceHost\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, piwiktesturl)
        XCTAssertEqual(sheetsQueryEdit/*@START_MENU_TOKEN@*/.staticTexts["EditInstanceLastCheck"]/*[[".staticTexts[\"29.10.2019, 17:33\"]",".staticTexts[\"EditInstanceLastCheck\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertEqual(sheetsQueryEdit.textFields["EditInstanceApiToken"].value as! String, piwiktestapikey)
        sheetsQueryEdit/*@START_MENU_TOKEN@*/.buttons["EditInstanceSave"]/*[[".buttons[\"Save\"]",".buttons[\"EditInstanceSave\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        self.deletePiwikTestinstance()
    }
    
    func deletePiwikTestinstance() {
        versionDashboardWindow.tables.staticTexts[piwiktestinstancename].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RemoveInstanceButton"]/*[[".buttons[\"-\"]",".buttons[\"RemoveInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let cell = versionDashboardWindow.tables["InstanceTableView"].cells.containing(.staticText, identifier: piwiktestinstancename)
        XCTAssertEqual(cell.textFields.count, 0)
    }
    
}
