//
//  OutdatedViewControllerTests.swift
//  VersionDashboardiOSTests
//
//  Created by Christian Schneider on 03.11.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardiOSSimulator
@testable import VersionDashboardSDK

class OutdatedViewControllerTests: XCTestCase {
    
    var testobjectJoomla: JoomlaModel!
    var testobjectOwncloud: OwncloudModel!
    var testobjectWordpress: WordpressModel!
    var testobjectPiwik: PiwikModel!
    var outdatedViewController: OutdatedViewController!

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        self.createInstances()
        XCTAssert(SystemInstancesModel.loadConfigfiles())
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let outdatedViewController = storyBoard.instantiateViewController(withIdentifier: "OutdatedViewController") as! OutdatedViewController
        _ = outdatedViewController.view
    }

    override func tearDown() {
        XCTAssert(GenericModel.deleteFile(testobjectPiwik.name))
        XCTAssert(GenericModel.deleteFile(testobjectWordpress.name))
        XCTAssert(GenericModel.deleteFile(testobjectOwncloud.name))
        XCTAssert(GenericModel.deleteFile(testobjectJoomla.name))
        
        super.tearDown()
    }
    
    func testLoadOutdatedInstances() {
        XCTAssertEqual(SystemInstancesModel.getAmountOfOutdateInstances(), 1)
    }
    
    func createInstances() {
        testobjectJoomla = JoomlaModel(creationDate: "03-04-2016", currentVersion: "3.9.12", hosturl: Constants.joomlaAPIUrl, headVersion: (HeadInstances.headInstances["Joomla"] as! JoomlaHeadModel).headVersion, lastRefresh: "25.10.2019, 19:53", name: "Joomlatestinstance", type: "Joomla", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectJoomla.saveConfigfile())
        
        testobjectPiwik = PiwikModel(creationDate: "06-04-2016", currentVersion: "3.11.0", hosturl: "https://piwik.demo.org/", apiToken: "1234567890", lastRefresh: "26.10.2019, 22:38", name: "Piwiktestinstance", type: "Piwik", headVersion: (HeadInstances.headInstances["Piwik"] as! PiwikHeadModel).headVersion, updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectPiwik.saveConfigfile())
        
        testobjectWordpress = WordpressModel(creationDate: "06-04-2016", currentVersion: "5.2.4", hosturl: "https://s1.demo.opensourcecms.com/wordpress/", headVersion: (HeadInstances.headInstances["Wordpress"] as! WordpressHeadModel).headVersion, lastRefresh: "26.10.2019, 22:38", name: "Wordpresstestinstance", type: "Wordpress", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectWordpress.saveConfigfile())
        
        testobjectOwncloud = OwncloudModel(creationDate: "06-04-2016", currentVersion: "10.2.0", hosturl: "https://demo.owncloud.com/", headVersion: (HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel).headVersion, lastRefresh: "26.10.2019, 22:38", name: "Owncloudtestinstance", type: "Owncloud", updateAvailable: 1, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectOwncloud.saveConfigfile())
    }

}
