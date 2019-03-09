//
//  PiwikHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

class PiwikHeadModel: GenericHeadModel, XMLParserDelegate {
    
    func getVersion(forceUpdate: Bool = false) {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersion(piwikLatestVersionURL)
            if(headVersion != "") {
                self.headVersion = headVersion
            } else {
                self.headVersion = "0.0"
            }
            if (self.saveConfigfile(filename: piwikHead)) {
                print("Error saving piwik head plist file.")
            }
        }
    }
    
    func getInstanceVersion(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            return version!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        return ""
    }
    
    func XMLParserError(_ parser: XMLParser, error: String) {
        print(error);
    }
    
}
