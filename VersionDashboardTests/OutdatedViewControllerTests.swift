//
//  OutdatedViewControllerTests.swift
//  VersionDashboardTests
//
//  Created by Christian Schneider on 28.10.19.
//  Copyright © 2019 NonameCompany. All rights reserved.
//

import XCTest
@testable import VersionDashboard
@testable import VersionDashboardSDK

class OutdatedViewControllerTests: XCTestCase {
    
    var testobjectJoomla: JoomlaModel!
    var testobjectOwncloud: OwncloudModel!
    var testobjectWordpress: WordpressModel!
    var testobjectPiwik: PiwikModel!
    var testobjectNextcloud: NextcloudModel!
    var vc: OutdatedViewController!

    override func setUp() {
        super.setUp()
        
        XCTAssert(HeadInstancesModel.loadConfigfiles())
        
        self.createInstances()
        XCTAssert(SystemInstancesModel.loadConfigfiles())
        
        let storyboard = NSStoryboard(name: "Main", bundle: Bundle.main)
        vc = (storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("OutdatedViewController")) as? OutdatedViewController)!
        _ = vc.view
    }
    
    func createInstances() {
        testobjectJoomla = JoomlaModel(creationDate: "03-04-2016", currentVersion: "3.9.12", hosturl: Constants.joomlaAPIUrl, headVersion: "3.9.12", lastRefresh: "25.10.2019, 19:53", name: "Joomlatestinstance", type: "Joomla", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectJoomla.saveConfigfile())
        
        testobjectPiwik = PiwikModel(creationDate: "06-04-2016", currentVersion: "3.11.0", hosturl: "https://piwik.demo.org/", apiToken: "1234567890", lastRefresh: "26.10.2019, 22:38", name: "Piwiktestinstance", type: "Piwik", headVersion: "3.11.0", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectPiwik.saveConfigfile())
        
        testobjectWordpress = WordpressModel(creationDate: "06-04-2016", currentVersion: "5.2.4", hosturl: "https://s1.demo.opensourcecms.com/wordpress/", headVersion: "5.2.4", lastRefresh: "26.10.2019, 22:38", name: "Wordpresstestinstance", type: "Wordpress", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectWordpress.saveConfigfile())
        
        testobjectOwncloud = OwncloudModel(creationDate: "06-04-2016", currentVersion: "10.2.0", hosturl: "https://demo.owncloud.com/", headVersion: "10.3.0", lastRefresh: "26.10.2019, 22:38", name: "Owncloudtestinstance", type: "Owncloud", updateAvailable: 1, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectOwncloud.saveConfigfile())
        
        testobjectNextcloud = NextcloudModel(creationDate: "06-04-2016", currentVersion: "10.3.0", hosturl: "https://demo2.nextcloud.com/", headVersion: "10.3.0", lastRefresh: "26.10.2019, 22:38", name: "Nextcloudtestinstance", type: "Nextcloud", updateAvailable: 0, phpVersion: "7.2.23", serverType: "Apache/2.2.15 (CentOS)")
        XCTAssert(testobjectNextcloud.saveConfigfile())
    }

    override func tearDown() {
        XCTAssert(GenericModel.deleteFile(testobjectPiwik.name))
        XCTAssert(GenericModel.deleteFile(testobjectWordpress.name))
        XCTAssert(GenericModel.deleteFile(testobjectOwncloud.name))
        XCTAssert(GenericModel.deleteFile(testobjectJoomla.name))
        XCTAssert(GenericModel.deleteFile(testobjectNextcloud.name))
        
        super.tearDown()
    }

    func testLoadOutdatedInstances() {
        XCTAssertEqual(OutdatedInstances.outdatedInstances.count, 1)
    }
    
    func testFilterInstances() {
        vc.filtertext = self.testobjectOwncloud.name.lowercased()
        vc.reloadTable()
        
        if (vc.filteredInstancesArray.isEmpty) {
            XCTAssert(false)
        }
        print(vc.filteredInstancesArray)
        for var instancename in vc.filteredInstancesArray {
            instancename = instancename.lowercased()
            if (!instancename.contains(vc.filtertext)) {
                XCTAssert(false)
            }
        }
        XCTAssert(true)
    }

}
