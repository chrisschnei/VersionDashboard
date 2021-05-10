//
//  GenericViewControllerTests.swift
//  VersionDashboardTests
//
//  Created by Christian Schneider on 20.04.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboard
@testable import VersionDashboardSDK

class GenericViewControllerTests: XCTestCase {
    
    var testobjectJoomla: JoomlaModel!
    var testobjectOwncloud: OwncloudModel!
    var testobjectWordpress: WordpressModel!
    var testobjectPiwik: PiwikModel!
    var testobjectNextcloud: NextcloudModel!
    var vc: GenericViewController!

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        self.createInstances()
        XCTAssert(SystemInstancesModel.loadConfigfiles())
        
        self.vc = GenericViewController()
    }

    override func tearDown() {
        XCTAssert(GenericModel.deleteFile(testobjectPiwik.name))
        XCTAssert(GenericModel.deleteFile(testobjectWordpress.name))
        XCTAssert(GenericModel.deleteFile(testobjectOwncloud.name))
        XCTAssert(GenericModel.deleteFile(testobjectJoomla.name))
        XCTAssert(GenericModel.deleteFile(testobjectNextcloud.name))
        
        super.tearDown()
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
        
        testobjectNextcloud = NextcloudModel(creationDate: "06-04-2016", currentVersion: "10.3.0", hosturl: "https://demo2.nextcloud.com/", headVersion: "10.3.0", lastRefresh: "26.10.2019, 22:38", name: "Nextcloudtestinstance", type: "Nextcloud", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectNextcloud.saveConfigfile())
    }

    func testCheckURLTextfields() {
        let field: NSTextField
        field = NSTextField(string: "http://test.de")
        
        let label: NSTextField
        label = NSTextField(string: "")
        XCTAssert(self.vc.checkURLTextfields(hostUrlTextfield: field, infoTitle: label))
        XCTAssertEqual(label.stringValue, NSLocalizedString("urlEnding", comment: ""))
        
        label.stringValue = ""
        field.stringValue = "ht://test.de/"
        XCTAssert(self.vc.checkURLTextfields(hostUrlTextfield: field, infoTitle: label))
        XCTAssertEqual(label.stringValue, NSLocalizedString("protocolMissing", comment: ""))
    }
    
    func testCopyToClipboardOwncloud() {
        (HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel).downloadurl = "https://test.de/"
        XCTAssert(vc.copyToClipboard())
        XCTAssertEqual(NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string), (HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel).downloadurl)
    }
    
    func testCopyToClipboardNextcloud() {
        (HeadInstances.headInstances["Nextcloud"] as! NextcloudHeadModel).downloadurl = "https://test.de/"
        XCTAssert(vc.copyToClipboard())
        XCTAssertEqual(NSPasteboard.general.string(forType: NSPasteboard.PasteboardType.string), (HeadInstances.headInstances["Nextcloud"] as! NextcloudHeadModel).downloadurl)
    }
    
    func testInstantiateDetailedViewController() {
        XCTAssertNotNil(vc.instantiateDetailedViewController())
    }
    
    func testInstantiateOutdatedViewController() {
        XCTAssertNotNil(vc.instantiateOutdatedViewController())
    }
    
    func testInstantiateSummaryViewController() {
        XCTAssertNotNil(vc.instantiateSummaryViewController())
    }
    
    func testInstantiateOwncloudViewController() {
        XCTAssertNotNil(vc.instantiateOwncloudViewController())
    }
    
    func testInstantiateJoomlaViewController() {
        XCTAssertNotNil(vc.instantiateJoomlaViewController())
    }
    
    func testInstantiateWordpressViewController() {
        XCTAssertNotNil(vc.instantiateWordpressViewController())
    }
    
    func testInstantiatePiwikViewController() {
        XCTAssertNotNil(vc.instantiatePiwikViewController())
    }
    
    func testOpenInstanceWebsite() {
        let filteredArray = Array<String>()
        let selectedRow = 0
        
        XCTAssert(vc.openInstanceWebsite(selectedRow: selectedRow, filteredInstancesArray: filteredArray, filtertext: ""))
    }

}
