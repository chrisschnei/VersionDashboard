//
//  PreferencesViewControllerTests.swift
//  VersionDashboardTests
//
//  Created by Christian Schneider on 28.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboard
@testable import VersionDashboardSDK

class PreferencesViewControllerTests: XCTestCase {
    
    var vc: PreferencesViewController!

    override func setUp() {
        super.setUp()
        
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        vc = (storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("PreferencesViewController")) as? PreferencesViewController)!
        _ = vc.view
    }

    override func tearDown() {
        super.tearDown()
    }

    func testViewDidLoad() {
        XCTAssertEqual(vc.dropdownInterval.numberOfItems, 4)
        XCTAssert(vc.activatedCheckbox.isEnabled)
    }
    
    func testSaveConfigurationFiles() {
        XCTAssert(vc.saveConfigurationFile())
    }

}
