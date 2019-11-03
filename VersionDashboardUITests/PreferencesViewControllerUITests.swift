//
//  PreferencesViewControllerUITests.swift
//  VersionDashboardUITests
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import XCTest

class PreferencesViewControllerUITests: XCTestCase {
        
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
        let menuBarsQuery = app.menuBars
        let versiondashboardMenuBarItem = menuBarsQuery.menuBarItems["VersionDashboard"]
        versiondashboardMenuBarItem.click()
        
        /* Test preferences cancel button */
        let preferencesMenuItem = menuBarsQuery/*@START_MENU_TOKEN@*/.menuItems["Preferences…"]/*[[".menuBarItems[\"VersionDashboard\"]",".menus.menuItems[\"Preferences…\"]",".menuItems[\"Preferences…\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        preferencesMenuItem.click()
        app/*@START_MENU_TOKEN@*/.buttons["PreferencesCancelButton"]/*[[".dialogs[\"Preferences\"]",".buttons[\"Cancel\"]",".buttons[\"PreferencesCancelButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.click()
        
        /* Test preferences save button */
        versiondashboardMenuBarItem.click()
        preferencesMenuItem.click()
        
        let automaticrefreshactivatedCheckBox = app/*@START_MENU_TOKEN@*/.checkBoxes["AutomaticRefreshActivated"]/*[[".dialogs[\"Preferences\"].checkBoxes[\"AutomaticRefreshActivated\"]",".checkBoxes[\"AutomaticRefreshActivated\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssert(automaticrefreshactivatedCheckBox.isEnabled)
        let activated = automaticrefreshactivatedCheckBox.value as! Bool
        XCTAssert(activated)
        automaticrefreshactivatedCheckBox.click()
        
        let button = app/*@START_MENU_TOKEN@*/.comboBoxes["AutomaticRefreshInterval"]/*[[".dialogs[\"Preferences\"].comboBoxes[\"AutomaticRefreshInterval\"]",".comboBoxes[\"AutomaticRefreshInterval\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .button).element
        button.click()
        
        let elementsQuery = app/*@START_MENU_TOKEN@*/.comboBoxes["AutomaticRefreshInterval"]/*[[".dialogs[\"Preferences\"].comboBoxes[\"AutomaticRefreshInterval\"]",".comboBoxes[\"AutomaticRefreshInterval\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*//*@START_MENU_TOKEN@*/.scrollViews/*[[".dialogs[\"Preferences\"]",".comboBoxes[\"AutomaticRefreshInterval\"].scrollViews",".scrollViews"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        let amount = app/*@START_MENU_TOKEN@*/.comboBoxes["AutomaticRefreshInterval"]/*[[".dialogs[\"Preferences\"].comboBoxes[\"AutomaticRefreshInterval\"]",".comboBoxes[\"AutomaticRefreshInterval\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*//*@START_MENU_TOKEN@*/.scrollViews/*[[".dialogs[\"Preferences\"]",".comboBoxes[\"AutomaticRefreshInterval\"].scrollViews",".scrollViews"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.descendants(matching: .textField)
        XCTAssertEqual(amount.count, 4)
        elementsQuery.descendants(matching: .textField).element(boundBy: 2).click()
        
        let preferencessavebuttonButton = app/*@START_MENU_TOKEN@*/.buttons["PreferencesSaveButton"]/*[[".dialogs[\"Preferences\"]",".buttons[\"Save\"]",".buttons[\"PreferencesSaveButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        preferencessavebuttonButton.click()
        
        /* Check settings */
        versiondashboardMenuBarItem.click()
        preferencesMenuItem.click()
        let selectedInterval = app/*@START_MENU_TOKEN@*/.comboBoxes["AutomaticRefreshInterval"]/*[[".dialogs[\"Preferences\"].comboBoxes[\"AutomaticRefreshInterval\"]",".comboBoxes[\"AutomaticRefreshInterval\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.value!
        XCTAssertEqual(selectedInterval as! String, "24")
        let deactivated = automaticrefreshactivatedCheckBox.value as! Bool
        XCTAssertFalse(deactivated)
        preferencessavebuttonButton.click()
        
        /* Restore start configuration */
        versiondashboardMenuBarItem.click()
        preferencesMenuItem.click()
        automaticrefreshactivatedCheckBox.click()
        button.click()
        elementsQuery.descendants(matching: .textField).element(boundBy: 0).click()
        preferencessavebuttonButton.click()
    }
    
}
