//
//  OwncloudHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

class OwncloudHeadModel: GenericHeadModel {
    
    func getVersion(forceUpdate: Bool = false) {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-refreshHeadInstances)))) {
            let headVersion = self.getLatestVersion(owncloudAPIUrl)
            if(headVersion != "") {
                self.headVersion = headVersion
            }
        }
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
    
}
