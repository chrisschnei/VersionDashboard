//
//  GenericViewControllerTests.swift
//  VersionDashboardiOSTests
//
//  Created by Christian Schneider on 03.11.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboardiOSSimulator
@testable import VersionDashboardSDK

class GenericViewControllerTests: XCTestCase {

    var testobjectJoomla: JoomlaModel!
    var testobjectOwncloud: OwncloudModel!
    var testobjectWordpress: WordpressModel!
    var testobjectPiwik: PiwikModel!
    var genericViewController: GenericViewController!
    
    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        self.createInstances()
        XCTAssert(SystemInstancesModel.loadConfigfiles())
        
        self.genericViewController = GenericViewController()
    }

    override func tearDown() {
        _ = GenericModel.deleteFile(self.testobjectPiwik.name)
        _ = GenericModel.deleteFile(self.testobjectWordpress.name)
        _ = GenericModel.deleteFile(self.testobjectOwncloud.name)
        _ = GenericModel.deleteFile(self.testobjectJoomla.name)
        
        self.genericViewController = nil
        super.tearDown()
    }

    func testTakeMeToMyInstance() {
        XCTAssert(self.genericViewController.takeMeToMyInstance(self.testobjectJoomla.name))
    }
    
    func testDeleteInstance() {
        let path = (Constants.plistFilesPath + self.testobjectJoomla.name) + ".plist"
        XCTAssert(self.genericViewController.deleteInstance(path, self.testobjectJoomla.name))
    }
    
    func testCheckURLTextfields() {
        let point = CGPoint(x: 1, y: 1)
        let size = CGSize(width: 1, height: 1)
        let rect = CGRect(origin: point, size: size)
        
        let field: UITextField
        field = UITextField(frame: rect)
        field.text = "http://test.de"
        
        let label: UILabel
        label = UILabel(frame: rect)
        label.text = ""
        XCTAssert(self.genericViewController.checkURLTextfields(hostUrlTextfield: field, infoTitle: label))
        XCTAssertEqual(label.text, NSLocalizedString("urlEnding", comment: ""))
        
        field.text = "ht://test.de/"
        XCTAssert(self.genericViewController.checkURLTextfields(hostUrlTextfield: field, infoTitle: label))
        XCTAssertEqual(label.text, NSLocalizedString("protocolMissing", comment: ""))
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
