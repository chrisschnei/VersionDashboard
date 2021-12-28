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
            if let data = try? Data(contentsOf: URL(string: Constants.joomlaAPIUrl)!) {
                let version = String(data: data, encoding: String.Encoding.utf8)
                let lines = version?.components(separatedBy: "\n")
                var headVersion = ""

                for part in lines! {
                    if part.contains("4.0.5") {
                        print("pause here")
                    }
                        headVersion = self.getLatestVersion(part)
                        let versionCompare = self.headVersion.compare(headVersion, options: .numeric)
                        if versionCompare == .orderedSame {
                            // execute if current == appStore
                        } else if versionCompare == .orderedAscending {
                            // execute if current < appStore; update available
                            self.headVersion = headVersion
                        } else if versionCompare == .orderedDescending {
                            // execute if current > appStore
                        }
                }

                if (!self.saveConfigfile(filename: Constants.joomlaHead)) {
                    print("Error saving joomla head plist file.")
                    return false
                }
            } else {
                print("Fetching joomla head infos did not work.")
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
    
    /**
     Parse version string from HTML content.
     
     - Parameters:
     - content: Fetched owncloud data from website.
     - Returns: String containing version number in success case; empty in error case
     */
    func getLatestVersion(_ content: String) -> String {
        guard let range = content.range(of: "Joomla! [0-9]*[.][0-9]*[.][0-9]*", options: .regularExpression)
            else {
                return ""
        }
        if (content[range].components(separatedBy: " ")[1] != "") {
            return String(content[range].components(separatedBy: " ")[1])
        } else {
            return ""
        }
    }
    
}
