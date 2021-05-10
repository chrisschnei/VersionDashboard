//
//  NextcloudHeadModel.swift
//  VersionDashboard
//
//  Created by Christian Schneider on 20.02.21.
//  Copyright © 2021 NonameCompany. All rights reserved.
//

import Foundation

open class NextcloudHeadModel: GenericHeadModel {
    
    /**
     Get version from nextcloud vendor server.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    override public func updateHeadObject(forceUpdate: Bool = false) -> Bool {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            if let data = try? Data(contentsOf: URL(string: (Constants.nextcloudAPIUrl + Constants.nextcloudStatusFile))!) {
                if (data.isEmpty) {
                    print("Querying nextcloud head version failed")
                    return false
                }
                let version = String(data: data, encoding: String.Encoding.utf8)
                let lines = version?.components(separatedBy: "\n")
                var headVersion = ""
                var downloadUrl = ""
                
                for part in lines! {
                    if (headVersion == "") {
                        headVersion = self.getLatestVersion(part)
                    }
                    if (downloadUrl == "") {
                        downloadUrl = self.getDownloadUrl(part)
                    }
                }
                
                self.headVersion = headVersion
                self.downloadurl = downloadUrl
                
                if (!self.saveConfigfile(filename: Constants.nextcloudHead)) {
                    print("Error saving nextcloud head plist file.")
                    return false
                }
            } else {
                print("Fetching nextcloud head infos did not work.")
                return false
            }
        }
        
        return true
    }
    
    /**
     Parse version string from HTML content.
     
     - Parameters:
     - content: Fetched nextcloud data from website.
     - Returns: String containing version number
     */
    func getLatestVersion(_ content: String) -> String {
        guard let range = content.range(of: "nextcloud-[0-9]*[.][0-9]*[.]*[0-9]*.zip", options: .regularExpression)
            else {
                return ""
        }
        return String(content[range]).replacingOccurrences(of: "nextcloud-", with: "").replacingOccurrences(of: ".zip", with: "")
    }
    
    /**
     Parse download url string from HTML content.
     
     - Parameters:
     - content: Fetched nextcloud data from website.
     - Returns: String containing download url
     */
    func getDownloadUrl(_ line: String) -> String {
        if let range2 = line.range(of: Constants.nextcloudRegexDownload, options: .regularExpression) {
            return String(line[range2])
        }
        return ""
    }
}
