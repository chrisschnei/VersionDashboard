//
//  PiwikHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

open class PiwikHeadModel: GenericHeadModel, XMLParserDelegate {
    
    /**
     Get version from piwik vendor server.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    func getVersion(forceUpdate: Bool = false) {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersion(Constants.piwikLatestVersionURL)
            if(headVersion != "") {
                self.headVersion = headVersion
            } else {
                self.headVersion = "0.0"
            }
            if (!self.saveConfigfile(filename: Constants.piwikHead)) {
                print("Error saving piwik head plist file.")
            }
        }
    }
    
    /**
     Get version from piwik vendor server.
     
     - Parameters:
     - url: URL to piwik vendor version string page.
     - Returns: String containing version number
     */
    func getInstanceVersion(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            return version!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        return ""
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
    
}
