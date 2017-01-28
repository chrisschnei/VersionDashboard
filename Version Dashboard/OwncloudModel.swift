//
//  OwncloudModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class OwncloudModel : GenericModel {
    
    func getVersions() -> Bool {
        let headVersion = self.getLatestVersion(owncloudAPIUrl)
        let currentVersion = self.getInstanceVersion((self.hosturl) + owncloudStatusFile)
        self.phpVersionRequest(self.phpReturnHandler)
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    func getLatestVersion(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            let lines = version?.components(separatedBy: "\n")
            for part in lines! {
                if(part.range(of: "Latest stable version:") != nil) {
                    let part2 = part.components(separatedBy: "<strong>")
                    let part3 = part2[1].components(separatedBy: "</strong>")
                    if(part3[0] != "" && !part3[0].isEmpty) {
                        return part3[0]
                    }
                }
            }
        }
        return ""
    }

    
    func getInstanceVersion(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            let lines = version?.components(separatedBy: "\n")
            for part in lines! {
                if(part.range(of: "versionstring") != nil) {
                    let part2 = part.components(separatedBy: ",")
                    for element in part2 {
                        if((element.range(of: "versionstring")) != nil) {
                            let element2 = element.components(separatedBy: ":")
                            let version = (element2[1].replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range: nil))
                            return version
                        }
                    }
                }
            }
        }
        return ""
    }
}
