//
//  DetailedViewControllerUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboard
@testable import VersionDashboardSDK

class DetailedViewControllerUITests: XCTestCase {
    
    var testobjectJoomla: JoomlaModel!
    var testobjectOwncloud: OwncloudModel!
    var testobjectWordpress: WordpressModel!
    var testobjectPiwik: PiwikModel!
        
    override func setUp() {
        super.setUp()
        
        self.createInstances()
        
        continueAfterFailure = false
        
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        XCTAssert(GenericModel.deleteFile(testobjectPiwik.name))
        XCTAssert(GenericModel.deleteFile(testobjectWordpress.name))
        XCTAssert(GenericModel.deleteFile(testobjectOwncloud.name))
        XCTAssert(GenericModel.deleteFile(testobjectJoomla.name))
        
        super.tearDown()
    }
    
    func createInstances() {
        testobjectJoomla = JoomlaModel(creationDate: "03-04-2016", currentVersion: "3.9.12", hosturl: Constants.joomlaAPIUrl, headVersion: "3.9.12", lastRefresh: "25.10.2019, 19:53", name: "Joomlatestinstance", type: "Joomla", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectJoomla.saveConfigfile())
        
        testobjectPiwik = PiwikModel(creationDate: "06-04-2016", currentVersion: "3.11.0", hosturl: "https://piwik.demo.org/", apiToken: "1234567890", lastRefresh: "26.10.2019, 22:38", name: "Piwiktestinstance", type: "Piwik", headVersion: "3.11.0", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectPiwik.saveConfigfile())
        
        testobjectWordpress = WordpressModel(creationDate: "06-04-2016", currentVersion: "5.2.4", hosturl: "https://s1.demo.opensourcecms.com/wordpress/", headVersion: "5.2.4", lastRefresh: "26.10.2019, 22:38", name: "Wordpresstestinstance", type: "Wordpress", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectWordpress.saveConfigfile())
        
        testobjectOwncloud = OwncloudModel(creationDate: "06-04-2016", currentVersion: "10.3.0", hosturl: "https://demo.owncloud.com/", headVersion: "10.3", lastRefresh: "26.10.2019, 22:38", name: "Owncloudtestinstance", type: "Owncloud", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectOwncloud.saveConfigfile())
    }
    
    func testViewDidLoad() {
        let versionDashboardWindow = XCUIApplication().windows["Version Dashboard"]
        versionDashboardWindow.toolbars.buttons["Detailed View"].click()
        versionDashboardWindow/*@START_MENU_TOKEN@*/.tables/*[[".scrollViews.tables",".tables"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .tableRow).element(boundBy: 0).cells.element.click()
        
        /* Check text content */
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["SystemLabel"].value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["HostLabel"]/*[[".staticTexts[\"https:\/\/asana24.net\/piwik\/\"]",".staticTexts[\"HostLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["StatusLabel"]/*[[".staticTexts[\"ok\"]",".staticTexts[\"StatusLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["LastCheckLabel"].value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["CurrentVersionLabel"].value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow.staticTexts["LatestVersionLabel"].value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["PhpVersionLabel"]/*[[".staticTexts[\"7.2.23\"]",".staticTexts[\"PhpVersionLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        XCTAssertNotEqual(versionDashboardWindow/*@START_MENU_TOKEN@*/.staticTexts["WebserverLabel"]/*[[".staticTexts[\"Apache\/2.2.15 (CentOS)\"]",".staticTexts[\"WebserverLabel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value as! String, "")
        
        /* Check buttons and spinner */
        XCTAssert(versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RefreshButton"]/*[[".buttons[\"Refresh\"]",".buttons[\"RefreshButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled)
        XCTAssert(versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["RefreshButton"]/*[[".buttons[\"Refresh\"]",".buttons[\"RefreshButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isHittable)
        XCTAssert(versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["TakeMeToMyInstanceButton"]/*[[".buttons[\"Take me to my instance\"]",".buttons[\"TakeMeToMyInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isEnabled)
        XCTAssert(versionDashboardWindow/*@START_MENU_TOKEN@*/.buttons["TakeMeToMyInstanceButton"]/*[[".buttons[\"Take me to my instance\"]",".buttons[\"TakeMeToMyInstanceButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.isHittable)
        XCTAssert(versionDashboardWindow.buttons["EditInstanceButton"].isEnabled)
        XCTAssert(versionDashboardWindow.buttons["EditInstanceButton"].isHittable)
        XCTAssert(versionDashboardWindow.buttons["RemoveInstanceButton"].isEnabled)
        XCTAssert(versionDashboardWindow.buttons["RemoveInstanceButton"].isHittable)
        XCTAssert(versionDashboardWindow.buttons["AddInstanceButton"].isEnabled)
        XCTAssert(versionDashboardWindow.buttons["AddInstanceButton"].isEnabled)
        XCTAssertNotNil(versionDashboardWindow.activityIndicators["RefreshSpinner"])
        XCTAssertNotNil(versionDashboardWindow.activityIndicators["ErrorLabel"])
    }
    
}
