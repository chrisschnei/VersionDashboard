//
//  JoomlaModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class JoomlaModel : GenericModel, XMLParserDelegate {
    
    func getVersions() -> Bool {
        let headVersion = self.getInstanceVersion(joomlaAPIUrl.stringByAppendingString(joomlapath))
        let currentVersion = self.getInstanceVersion((self.hosturl).stringByAppendingString(joomlapath))
        self.phpVersionRequest(self.phpReturnHandler)
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    func XMLParserError(parser: XMLParser, error: String) {
        print(error);
    }
    
    func getInstanceVersion(url: String) -> String {
        let pathToXml = NSURL(string: url)
        let parser = XMLParser(url: pathToXml!);
        
        parser.delegate = self;
        let s = parser.parse {
        }
        return s
    }
}
