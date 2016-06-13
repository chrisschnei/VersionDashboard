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
        let currentVersion = self.getInstanceVersion((self.hosturl).stringByAppendingString(owncloudStatusFile))
        self.phpVersionRequest(self.phpReturnHandler)
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    func getLatestVersion(url: String) -> String {
        if let version = NSData(contentsOfURL: NSURL(string: url)!) {
            let version = String(data: version, encoding: NSUTF8StringEncoding)
            let lines = version?.componentsSeparatedByString("\n")
            for part in lines! {
                if(part.rangeOfString("Latest stable version:") != nil) {
                    let part2 = part.componentsSeparatedByString("<span class=\"label label-blue\">")
                    let part3 = part2[1].componentsSeparatedByString("</span>")
                    if(part3[0] != "" && !part3[0].isEmpty) {
                        return part3[0]
                    }
                }
            }
        }
        return ""
    }

    
    func getInstanceVersion(url: String) -> String {
        if let version = NSData(contentsOfURL: NSURL(string: url)!) {
            let version = String(data: version, encoding: NSUTF8StringEncoding)
            let lines = version?.componentsSeparatedByString("\n")
            for part in lines! {
                if(part.rangeOfString("versionstring") != nil) {
                    let part2 = part.componentsSeparatedByString(",")
                    for element in part2 {
                        if((element.rangeOfString("versionstring")) != nil) {
                            let element2 = element.componentsSeparatedByString(":")
                            let version = (element2[1].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
                            return version
                        }
                    }
                }
            }
        }
        return ""
    }
}