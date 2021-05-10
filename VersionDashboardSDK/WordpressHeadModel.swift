//
//  WordpressHeadModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 06.10.17.
//  Copyright © 2017 NonameCompany. All rights reserved.
//

import Foundation

open class WordpressHeadModel: GenericHeadModel {
    
    /**
     Get version from piwik vendor server.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    override public func updateHeadObject(forceUpdate: Bool = false) -> Bool {
        if (forceUpdate || (self.lastRefresh <= Date().addingTimeInterval(TimeInterval(-Constants.refreshHeadInstances)))) {
            let headVersion = self.getInstanceVersionJSON()
            if(headVersion != "") {
                self.headVersion = headVersion
            } else {
                self.headVersion = "0.0"
                return false
            }
            if (!self.saveConfigfile(filename: Constants.wordpressHead)) {
                print("Error saving wordpress head plist file.")
                return false
            }
        }
        
        return true
    }
    
    /**
     Get version from wordpress vendor server.
     
     - Returns: String containing version number
     */
    func getInstanceVersionJSON() -> String {
        if let version = try? Data(contentsOf: URL(string: Constants.wordpressAPIUrl)!) {
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
