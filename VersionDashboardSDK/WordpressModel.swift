//
//  WordpressModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

public class WordpressModel : GenericModel {
    
    /**
     Fetches versions from wordpress head and custom instance.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    open override func getVersions(forceUpdate: Bool) -> Bool {
        let wordpressheadobject = HeadInstances.headInstances["Wordpress"] as! WordpressHeadModel
        if (!wordpressheadobject.updateHeadObject(forceUpdate: forceUpdate)) {
            print("Could not get wordpress head version. Abort further checking.")
            return false
        }
        let currentVersion = self.getInstanceVersion(self.hosturl)
        self.phpVersionRequest(self.phpReturnHandler)
        if(currentVersion != "") {
            self.currentVersion = currentVersion
            self.headVersion = wordpressheadobject.headVersion
            return true
        }
        
        self.currentVersion = "0.0"
        self.headVersion = "0.0"
        return false
    }
    
    /**
     Extract version string from javascript file.
     
     - Parameters:
     - url: url to javascript file
     - Returns: string containing version number, empty string in error case.
     */
    func checkVersionViaJavascript(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            let lines = version?.components(separatedBy: "\n")
            for part in lines! {
                if(part.range(of: "wp-embed.min.js?ver=") != nil) {
                    let part2 = part.components(separatedBy: "wp-embed.min.js?ver=")
                    let part3 = part2[1].components(separatedBy: "'")
                    return part3[0]
                }
            }
        }
        return ""
    }
    
    /**
     Extract wordpress version number from emoji javascript part.
     
     - Parameters:
     - url: contains url to javascript file
     - Returns: version number string on success, empty string in error case.
     */
    func checkVersionViaJavascriptEmoji(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            let lines = version?.components(separatedBy: "\n")
            for part in lines! {
                if(part.range(of: "wp-emoji-release.min.js?ver=") != nil) {
                    let part2 = part.components(separatedBy: "wp-emoji-release.min.js?ver=")
                    let part3 = part2[1].components(separatedBy: "\"")
                    return part3[0]
                }
            }
        }
        return ""
    }
    
    /**
     Extracts wordpress version number from rss feed.
     
     - Parameters:
     - url: URL to rss feed.
     - Returns: version number string on success, empty string in error case.
     */
    func checkVersionViaRSSFeed(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            let lines = version?.components(separatedBy: "\n")
            for part in lines! {
                if(part.range(of: "<generator>") != nil) {
                    let part2 = part.components(separatedBy: "=")
                    let part3 = part2[1].components(separatedBy: "</")
                    return part3[0]
                }
            }
        }
        return ""
    }
    
    /**
     Checks wordpress instance version using different wordpress specific sources in an instance.
     
     - Parameters:
     - url: URL to custom wordpress instance
     - Returns: version number string on success, empty string in error case.
     */
    func getInstanceVersion(_ url: String) -> String {
        if(url != "") {
            var result = ""
            result = checkVersionViaJavascriptEmoji(url)
            if(result != "") {
                return result
            }
            result = self.checkVersionViaJavascript(url)
            if(result != "") {
                return result
            }
            result = self.checkVersionViaRSSFeed(url + "feed")
            if(result != "") {
                return result
            }
            return result
        }
        return ""
    }
    
    /**
     Extracts wordpress version from json file.
     
     - Parameters:
     - url: URL to json file.
     - Returns: version number string on success, empty string in error case.
     */
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
