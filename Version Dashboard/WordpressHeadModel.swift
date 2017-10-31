//
//  WordpressHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

class WordpressHeadModel: GenericHeadModel {
    
    func getVersion(forceUpdate: Bool = false) {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersionJSON(wordpressAPIUrl)
            if(headVersion != "") {
                self.headVersion = headVersion
            }
        }
    }
    
    func getInstanceVersionJSON(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            do {
                let json = try JSONSerialization.jsonObject(with: version, options: .allowFragments) as! [String:Any]
                if json["offers"] != nil {
                    let versionarray = (json["offers"]! as! NSArray).mutableCopy() as! NSMutableArray
                    let versionarrayobject = versionarray[0] as AnyObject
                    return versionarrayobject["current"] as! String
                }
            } catch {
                
            }
        }
        return ""
    }
    
}
