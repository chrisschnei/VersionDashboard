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
        let headVersion = self.getInstanceVersion(owncloudAPIUrl.stringByAppendingString(owncloudVersionURL))
        let currentVersion = self.getInstanceVersion((self.hosturl).stringByAppendingString(owncloudVersionURL))
        self.phpVersionRequest(self.phpReturnHandler)
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    override func checkNotificationRequired() {
        if((self.headVersion.rangeOfString(self.currentVersion) == nil) && (self.updateAvailable == 0)) {
            self.updateAvailable = 1
            incrementBadgeNumber()
            sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), self.name)))
            self.saveConfigfile()
        } else if((self.headVersion.rangeOfString(self.currentVersion) != nil) && (self.updateAvailable == 1)) {
            self.updateAvailable = 0
            decrementBadgeNumber()
        }
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