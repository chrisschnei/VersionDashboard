//
//  OwncloudModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class OwncloudModel : GenericModel {
    
    /**
     Get version from custom owncloud instance server.
     
     - Parameters:
     - forceUpdate: true to retrieve version string and ignore time interval, false if time interval should be respected.
     - Returns: true if version string download succeeded, false on error
     */
    open override func getVersions(forceUpdate: Bool) -> Bool {
        let owncloudheadobject = HeadInstances.headInstances["Owncloud"] as! OwncloudHeadModel
        if (!owncloudheadobject.updateHeadObject(forceUpdate: forceUpdate)) {
            print("Could not get owncloud head version. Abort further checking.")
            return false
        }
        let currentVersion = self.getInstanceVersion()
        self.phpVersionRequest(self.phpReturnHandler)
        if(currentVersion != "") {
            self.currentVersion = currentVersion
            self.headVersion = owncloudheadobject.headVersion
            return true
        }
        
        self.currentVersion = "0.0"
        self.headVersion = "0.0"
        return false
    }

    /**
     Get version from owncloud vendor server.
     
     - Returns: String containing version number
     */
    func getInstanceVersion() -> String {
        if let version = try? Data(contentsOf: URL(string: self.hosturl + Constants.owncloudStatusFile)!) {
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
