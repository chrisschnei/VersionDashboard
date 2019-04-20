//
//  JoomlaModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class JoomlaModel : GenericModel, XMLParserDelegate {
    
    open func getVersions(forceUpdate: Bool) -> Bool {
        let joomlaheadobject = HeadInstances.headInstances["Joomla"] as! JoomlaHeadModel
        joomlaheadobject.getVersion(forceUpdate: forceUpdate)
        let currentVersion = self.getInstanceVersion((self.hosturl) + Constants.joomlapath)
        self.phpVersionRequest(self.phpReturnHandler)
        if(currentVersion != "") {
            self.currentVersion = currentVersion
            self.headVersion = joomlaheadobject.headVersion
            return true
        }
        
        self.currentVersion = "0.0"
        self.headVersion = "0.0"
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
