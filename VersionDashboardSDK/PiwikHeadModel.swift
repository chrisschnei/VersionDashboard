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
    override public func updateHeadObject(forceUpdate: Bool = false) -> Bool {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersion()
            if(headVersion != "") {
                self.headVersion = headVersion
            } else {
                self.headVersion = "0.0"
                return false
            }
            if (!self.saveConfigfile(filename: Constants.piwikHead)) {
                print("Error saving piwik head plist file.")
            }
        }
        
        return true
    }
    
    /**
     Get version from piwik vendor server.
     
     - Returns: String containing version number
     */
    func getInstanceVersion() -> String {
        if let version = try? Data(contentsOf: URL(string: Constants.piwikLatestVersionURL)!) {
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
