//
//  JoomlaModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class JoomlaModel : GenericModel, XMLParserDelegate {
    
    /**
     Get version from custom joomla instance server.
     
     - Parameters:
     - forceUpdate: true to retrieve version string and ignore time interval, false if time interval should be respected.
     - Returns: true if version string download succeeded, false on error
     */
    open override func getVersions(forceUpdate: Bool) -> Bool {
        let joomlaheadobject = HeadInstances.headInstances["Joomla"] as! JoomlaHeadModel
        if (!joomlaheadobject.getVersion(forceUpdate: forceUpdate)) {
            print("Getting version form joomla instance failed.")
            return false
        }
        let currentVersion = self.getInstanceVersion((self.hosturl) + Constants.joomlapath)
        self.phpVersionRequest(self.phpReturnHandler)
        if(currentVersion != "") {
            self.currentVersion = currentVersion
            self.headVersion = joomlaheadobject.headVersion
            return true
        }
        
        self.currentVersion = "0.0"
        self.headVersion = "0.0"
        
        print("Failure retrieving version string. Setting to 0.0")
        return false
    }
    
    /**
     Called on XML parser error.
     
     - Parameters:
     - parser: XML parser object
     - error: String with contains error details
     */
    func XMLParserError(_ parser: XMLParser, error: String) {
        print(error);
    }
    
    /**
     Get version from joomla vendor server.
     
     - Parameters:
     - url: URL to joomla vendor version string page.
     - Returns: String containing version number
     */
    func getInstanceVersion(_ url: String) -> String {
        let pathToXml = URL(string: url)
        let parser = VersionDashboardXMLParser(url: pathToXml!);
        if (!parser.startParsing()) {
            print("Error extracting joomla version string.")
        }
        return parser.version
    }
    
}
