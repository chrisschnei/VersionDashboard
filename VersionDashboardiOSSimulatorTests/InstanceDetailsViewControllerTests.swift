//
//  InstanceDetailsViewControllerTests.swift
//  VersionDashboardiOSTests
//
//  Created by Christian Schneider on 03.11.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardiOSSimulator
@testable import VersionDashboardSDK

class InstanceDetailsViewControllerTests: XCTestCase {
    
    var testobjectJoomla: JoomlaModel!
    var instanceDetailViewController: InstanceDetailsViewController!

    override func setUp() {
        super.setUp()
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        self.createInstances()
        XCTAssert(SystemInstancesModel.loadConfigfiles())
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        self.instanceDetailViewController = storyBoard.instantiateViewController(withIdentifier: "InstanceDetailsViewController") as? InstanceDetailsViewController
        self.instanceDetailViewController.systemInstancesName = self.testobjectJoomla.name
        _ = self.instanceDetailViewController.view
        self.instanceDetailViewController.viewDidLoad()
        self.instanceDetailViewController.fillWithData()
    }

    override func tearDown() {
        _ = GenericModel.deleteFile(self.testobjectJoomla.name)
        
        self.instanceDetailViewController = nil
        
        super.tearDown()
    }
    
    func createInstances() {
        self.testobjectJoomla = JoomlaModel(creationDate: "03-04-2016", currentVersion: "3.9.12", hosturl: Constants.joomlaAPIUrl, headVersion: (HeadInstances.headInstances["Joomla"] as! JoomlaHeadModel).headVersion, lastRefresh: "25.10.2019, 19:53", name: "Joomlatestinstance", type: "Joomla", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectJoomla.saveConfigfile())
    }

    func testInstanceDetailsView() {
        XCTAssertEqual(self.instanceDetailViewController.hostUrlTextfield.text, self.testobjectJoomla.hosturl)
        XCTAssertEqual(self.instanceDetailViewController.typeEditField.text, self.testobjectJoomla.type)
        XCTAssertEqual(self.instanceDetailViewController.instanceTitle.text, self.testobjectJoomla.name)
        XCTAssertEqual(self.instanceDetailViewController.headVersionNumber.text, self.testobjectJoomla.headVersion)
        XCTAssertEqual(self.instanceDetailViewController.instanceVersionNumber.text, self.testobjectJoomla.currentVersion)
        XCTAssertEqual(self.instanceDetailViewController.webserverDetails.text, self.testobjectJoomla.serverType)
        XCTAssertEqual(self.instanceDetailViewController.phpVersionDetails.text, self.testobjectJoomla.phpVersion)
    }

}
