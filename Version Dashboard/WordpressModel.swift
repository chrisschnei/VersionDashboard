//
//  WordpressModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class WordpressModel : GenericModel {
    
    func getVersions(forceUpdate: Bool) -> Bool {
        let wordpressheadobject = headInstances["Wordpress"] as! WordpressHeadModel
        wordpressheadobject.getVersion(forceUpdate: forceUpdate)
        let currentVersion = self.getInstanceVersion(self.hosturl)
        self.phpVersionRequest(self.phpReturnHandler)
        if(currentVersion != "") {
            self.currentVersion = currentVersion
            self.headVersion = wordpressheadobject.headVersion
            return true
        }
        return false
    }
    
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
    
    func checkVersionViaReadmeHtml(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            let lines = version?.components(separatedBy: "\n")
            for part in lines! {
                if(part.range(of: "Version") != nil) {
                    let part2 = part.components(separatedBy: " ")
                    return part2.last!
                }
            }
        }
        return ""
    }
    
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
