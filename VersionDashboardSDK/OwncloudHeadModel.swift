//
//  OwncloudHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

open class OwncloudHeadModel: GenericHeadModel {
    
    /**
     Get version from joomla vendor server.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    override public func updateHeadObject(forceUpdate: Bool = false) -> Bool {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            if let data = try? Data(contentsOf: URL(string: Constants.owncloudAPIUrl)!) {
                let version = String(data: data, encoding: String.Encoding.utf8)
                let lines = version?.components(separatedBy: "\n")
                var headVersion = ""
                var downloadUrl = ""
                
                for part in lines! {
                    if (headVersion == "") {
                        headVersion = self.getLatestVersion(part, lines!)
                    }
                    if (downloadUrl == "") {
                        downloadUrl = self.getDownloadUrl(part)
                    }
                }
                
                self.headVersion = headVersion
                self.downloadurl = downloadUrl
                
                if (!self.saveConfigfile(filename: Constants.owncloudHead)) {
                    print("Error saving owncloud head plist file.")
                    return false
                }
            } else {
                print("Fetching owncloud head infos did not work.")
                return false
            }
        }
    
        return true
    }
    
    /**
     Parse version string from HTML content.
     
     - Parameters:
     - content: Fetched owncloud data from website.
     - lines: Fetched owncloud data from website.
     - Returns: String containing version number
     */
    func getLatestVersion(_ content: String, _ lines: [String]) -> String {        
        if let range2 = content.range(of: Constants.owncloudRegexDownload, options: .regularExpression) {
            guard let range = content[range2].range(of: "[0-9]*[.][0-9]*[.][0-9]*", options: .regularExpression)
                else {
                    return ""
                }
            let fullversion = content[range2]
            return String(fullversion[range])
        }

        return ""
    }
    
    /**
     Parse download url string from HTML content.
     
     - Parameters:
     - content: Fetched owncloud data from website.
     - Returns: String containing download url
     */
    func getDownloadUrl(_ line: String) -> String {
          if let range2 = line.range(of: Constants.owncloudRegexDownload, options: .regularExpression) {
            return String(line[range2])
        }
        return ""
    }
}
