//
//  DetailedViewControllerTests.swift
//  VersionDashboardTests
//
//  Created by Christian Schneider on 28.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboard
@testable import VersionDashboardSDK

class DetailedViewControllerTests: XCTestCase {
    
    var testobjectJoomla: JoomlaModel!
    var testobjectOwncloud: OwncloudModel!
    var testobjectWordpress: WordpressModel!
    var testobjectPiwik: PiwikModel!
    var vc: DetailedViewController!

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        self.createInstances()
        XCTAssert(SystemInstancesModel.loadConfigfiles())
        
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        vc = (storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("DetailedViewController")) as? DetailedViewController)!
        _ = vc.view
    }

    override func tearDown() {
        XCTAssert(GenericModel.deleteFile(testobjectPiwik.name))
        XCTAssert(GenericModel.deleteFile(testobjectWordpress.name))
        XCTAssert(GenericModel.deleteFile(testobjectOwncloud.name))
        XCTAssert(GenericModel.deleteFile(testobjectJoomla.name))
        
        super.tearDown()
    }
    
    func createInstances() {
        testobjectJoomla = JoomlaModel(creationDate: "03-04-2016", currentVersion: "3.9.12", hosturl: Constants.joomlaAPIUrl, headVersion: (HeadInstances.headInstances["Joomla"] as! JoomlaHeadModel).headVersion, lastRefresh: "25.10.2019, 19:53", name: "Joomlatestinstance", type: "Joomla", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectJoomla.saveConfigfile())
        
        testobjectPiwik = PiwikModel(creationDate: "06-04-2016", currentVersion: "3.11.0", hosturl: "https://piwik.demo.org/", apiToken: "1234567890", lastRefresh: "26.10.2019, 22:38", name: "Piwiktestinstance", type: "Piwik", headVersion: (HeadInstances.headInstances["Piwik"] as! PiwikHeadModel).headVersion, updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectPiwik.saveConfigfile())
        
        testobjectWordpress = WordpressModel(creationDate: "06-04-2016", currentVersion: "5.2.4", hosturl: "https://s1.demo.opensourcecms.com/wordpress/", headVersion: (HeadInstances.headInstances["Wordpress"] as! WordpressHeadModel).headVersion, lastRefresh: "26.10.2019, 22:38", name: "Wordpresstestinstance", type: "Wordpress", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectWordpress.saveConfigfile())
        
        testobjectOwncloud = OwncloudModel(creationDate: "06-04-2016", currentVersion: "10.3.0", hosturl: "https://demo.owncloud.com/", headVersion: (HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel).headVersion, lastRefresh: "26.10.2019, 22:38", name: "Owncloudtestinstance", type: "Owncloud", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectOwncloud.saveConfigfile())
    }
    
    func testViewDidLoad() {
        XCTAssertFalse(vc.takeMeToMyInstance.isEnabled)
        XCTAssertEqual(vc.tableView.numberOfRows, SystemInstances.systemInstances.count)
    }
    
    func testUpdateInstanceDetails() {
        for instanceName in SystemInstances.systemInstances.keys {
            if (!instanceName.contains("testinstance")) {
                print("Testobject \(instanceName) not a newly created testmodel.")
                continue
            }
            
            let indexInstance = SystemInstances.systemInstances.index(forKey: instanceName)!
            
            vc.updateInstanceDetails(SystemInstances.systemInstances.distance(from: SystemInstances.systemInstances.startIndex, to: indexInstance))
            
            var hosturl = ""
            var name = ""
            var lastRefresh = ""
            var currentVersion = ""
            var phpVersion = ""
            var headVersion = ""
            var serverType = ""
            
            if (instanceName == testobjectJoomla.name) {
                hosturl = testobjectJoomla.hosturl
                name = testobjectJoomla.name
                lastRefresh = testobjectJoomla.lastRefresh
                currentVersion = testobjectJoomla.currentVersion
                phpVersion = testobjectJoomla.phpVersion
                headVersion = testobjectJoomla.headVersion
                serverType = testobjectJoomla.serverType
            } else if (instanceName == testobjectPiwik.name) {
                hosturl = testobjectPiwik.hosturl
                name = testobjectPiwik.name
                lastRefresh = testobjectPiwik.lastRefresh
                currentVersion = testobjectPiwik.currentVersion
                phpVersion = testobjectPiwik.phpVersion
                headVersion = testobjectPiwik.headVersion
                serverType = testobjectPiwik.serverType
            } else if (instanceName == testobjectOwncloud.name) {
                hosturl = testobjectOwncloud.hosturl
                name = testobjectOwncloud.name
                lastRefresh = testobjectOwncloud.lastRefresh
                currentVersion = testobjectOwncloud.currentVersion
                phpVersion = testobjectOwncloud.phpVersion
                headVersion = testobjectOwncloud.headVersion
                serverType = testobjectOwncloud.serverType
            } else if (instanceName == testobjectWordpress.name) {
                hosturl = testobjectWordpress.hosturl
                name = testobjectWordpress.name
                lastRefresh = testobjectWordpress.lastRefresh
                currentVersion = testobjectWordpress.currentVersion
                phpVersion = testobjectWordpress.phpVersion
                headVersion = testobjectWordpress.headVersion
                serverType = testobjectWordpress.serverType
            } else {
                XCTAssert(false)
            }
            
            XCTAssert(vc.takeMeToMyInstance.isEnabled)
            XCTAssertEqual(vc.statusLabel.stringValue, NSLocalizedString("ok", comment:""))
            XCTAssertEqual(vc.systemLabel.stringValue, name)
            XCTAssertEqual(vc.hostLabel.stringValue, hosturl)
            XCTAssertEqual(vc.lastcheckLabel.stringValue, lastRefresh)
            XCTAssertEqual(vc.latestsversionLabel.stringValue, headVersion)
            XCTAssertEqual(vc.deployedversionLabel.stringValue, currentVersion)
            XCTAssertEqual(vc.phpVersion.stringValue, phpVersion)
            XCTAssertEqual(vc.webserver.stringValue, serverType)
        }
    }
    
    func testFilterInstances() {
        vc.filtertext = self.testobjectOwncloud.name.lowercased()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTableContents"), object: nil)
        
        if (vc.filteredInstancesArray.isEmpty) {
            XCTAssert(false)
        }
        
        for var instancename in vc.filteredInstancesArray {
            instancename = instancename.lowercased()
            if (!instancename.contains(vc.filtertext)) {
                XCTAssert(false)
            }
        }
        XCTAssert(true)
    }

}
