//
//  JoomlaHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

open class JoomlaHeadModel: GenericHeadModel, XMLParserDelegate {
    
    /**
     Get version from joomla vendor server.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    func getVersion(forceUpdate: Bool = false) -> Bool {
//        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersion(Constants.joomlaAPIUrl + Constants.joomlapath)
            if(headVersion != "") {
                self.headVersion = headVersion
            } else {
                self.headVersion = "0.0"
            }
            if (!self.saveConfigfile(filename: Constants.joomlaHead)) {
                print("Error saving Joomla head plist file.")
                return false
            }
//        }
        
        return true
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
        let parser = MyXMLParser(url: pathToXml!);
        
        parser.delegate = self;
        let s = parser.parse {
        }
        return s
    }
    
}
