//
//  WordpressModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class WordpressModel : GenericModel {
    
    func getVersions() -> Bool {
        let headVersion = self.getInstanceVersionJSON(wordpressAPIUrl)
        let currentVersion = self.getInstanceVersion(self.hosturl)
        self.phpVersionRequest(self.phpReturnHandler)
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    func checkVersionViaJavascript(url: String) -> String {
        if let version = NSData(contentsOfURL: NSURL(string: url)!) {
            let version = String(data: version, encoding: NSUTF8StringEncoding)
            let lines = version?.componentsSeparatedByString("\n")
            for part in lines! {
                if(part.rangeOfString("wp-embed.min.js?ver=") != nil) {
                    let part2 = part.componentsSeparatedByString("wp-embed.min.js?ver=")
                    let part3 = part2[1].componentsSeparatedByString("'")
                    return part3[0]
                }
            }
        }
        return ""
    }
    
    func checkVersionViaReadmeHtml(url: String) -> String {
        if let version = NSData(contentsOfURL: NSURL(string: url)!) {
            let version = String(data: version, encoding: NSUTF8StringEncoding)
            let lines = version?.componentsSeparatedByString("\n")
            for part in lines! {
                if(part.rangeOfString("Version") != nil) {
                    let part2 = part.componentsSeparatedByString(" ")
                    return part2.last!
                }
            }
        }
        return ""
    }
    
    func checkVersionViaRSSFeed(url: String) -> String {
        if let version = NSData(contentsOfURL: NSURL(string: url)!) {
            let version = String(data: version, encoding: NSUTF8StringEncoding)
            let lines = version?.componentsSeparatedByString("\n")
            for part in lines! {
                if(part.rangeOfString("<generator>") != nil) {
                    let part2 = part.componentsSeparatedByString("=")
                    let part3 = part2[1].componentsSeparatedByString("</")
                    return part3[0]
                }
            }
        }
        return ""
    }
    
    func getInstanceVersion(url: String) -> String {
        if(url != "") {
            var result = ""
            result = self.checkVersionViaJavascript(url)
            if(result != "") {
                return result
            }
            result = self.checkVersionViaReadmeHtml(url.stringByAppendingString("readme.html"))
            if(result != "") {
                return result
            }
            result = self.checkVersionViaRSSFeed(url.stringByAppendingString("feed"))
            if(result != "") {
                return result
            }
            return result
        }
        return ""
    }
    
    func getInstanceVersionJSON(url: String) -> String {
        if let version = NSData(contentsOfURL: NSURL(string: url)!) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(version, options: .AllowFragments)
                if let version2 = json["offers"]!![0]["current"] {
                    return (version2 as! String)
                }
            } catch {
                
            }
        }
        return ""
    }
    
}