//
//  OwncloudHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

open class OwncloudHeadModel: GenericHeadModel {
    
    func getVersion(forceUpdate: Bool = false) {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            let headVersion = self.getLatestVersion(Constants.owncloudAPIUrl)
            if(headVersion != "") {
                self.headVersion = headVersion
            } else {
                self.headVersion = "0.0"
            }
            if (self.saveConfigfile(filename: Constants.owncloudHead)) {
                print("Error saving owncloud head plist file.")
            }
        }
    }
    
    func getLatestVersion(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            let lines = version?.components(separatedBy: "\n")
            for part in lines! {
                if(part.range(of: "<td>production</td>") != nil) {
                    let index = lines?.index(of: part)
                    let part2 = lines![index! + 1]
                    let part3 = part2.components(separatedBy: "<td>")
                    let part4 = part3[1].components(separatedBy: "</td>")
                    if(part4[0] != "" && !part4[0].isEmpty) {
                        return part4[0]
                    }
                }
            }
        }
        return ""
    }
    
}