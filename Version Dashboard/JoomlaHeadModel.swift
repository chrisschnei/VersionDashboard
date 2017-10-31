//
//  JoomlaHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

class JoomlaHeadModel: GenericHeadModel, XMLParserDelegate {
    
    func getVersion(forceUpdate: Bool = false) {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersion(joomlaAPIUrl + joomlapath)
            if(headVersion != "") {
                self.headVersion = headVersion
            }
        }
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
