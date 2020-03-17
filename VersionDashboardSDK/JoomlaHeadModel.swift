//
//  JoomlaHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

open class JoomlaHeadModel: GenericHeadModel {
    
    /**
     Get version from joomla vendor server.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    override public func updateHeadObject(forceUpdate: Bool = false) -> Bool {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersion(Constants.joomlaAPIUrl + Constants.joomlapath)
            if(headVersion != "") {
                self.headVersion = headVersion
            } else {
                self.headVersion = "0.0"
                return false
            }
            if (!self.saveConfigfile(filename: Constants.joomlaHead)) {
                print("Error saving Joomla head plist file.")
                return false
            }
        }
        
        return true
    }
    
    /**
     Get version from joomla instance.
     
     - Parameters:
     - url: URL to joomla instance version string page.
     - Returns: String containing version number
     */
    func getInstanceVersion(_ url: String) -> String {
        let pathToXml = URL(string: url)
        let parser = VersionDashboardXMLParser(url: pathToXml!);
        if (!parser.startParsing()) {
            print("Error extracting joomla head version string.")
        }
        return parser.version
    }
    
}
