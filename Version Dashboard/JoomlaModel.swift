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
        let headVersion = self.getInstanceVersion(joomlaAPIUrl + joomlapath)
        let currentVersion = self.getInstanceVersion((self.hosturl) + joomlapath)
        self.phpVersionRequest(self.phpReturnHandler)
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    func XMLParserError(_ parser: XMLParser, error: String) {
        print(error);
    }
    
    func getInstanceVersion(_ url: String) -> String {
        let pathToXml = URL(string: url)
        let parser = MyXMLParser(url: pathToXml!);
        
        parser.delegate = self;
        let s = parser.parse {
        }
        return s
    }
}
