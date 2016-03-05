//
//  WordpressModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class WordpressModel : GenericModel {
    var hosturl = String()
    var currentVersion = String()
    var lastRefresh = String()
    var headVersion = String()
    var creationDate = String()
    var updateAvailable = Int()
    var name = String()
    var type = String()
    
    init(creationDate: String, currentVersion: String, hosturl: String, lastRefresh: String, name: String, type: String, headVersion: String, updateAvailable: Int) {
        self.hosturl = hosturl
        self.currentVersion = currentVersion
        self.lastRefresh = lastRefresh
        self.headVersion = headVersion
        self.creationDate = creationDate
        self.updateAvailable = updateAvailable
        self.name = name
        self.type = type
    }
    
    func saveConfigfile() -> Bool {
        let path = appurl.stringByAppendingString(self.name).stringByAppendingString(".plist")
        let dict: NSMutableDictionary = NSMutableDictionary()
        
        if(self.creationDate == "") {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = dateformat
            self.creationDate = dateFormatter.stringFromDate(NSDate())
        }
        dict.setObject(self.hosturl, forKey: "hosturl")
        dict.setObject(self.name, forKey: "name")
        dict.setObject(self.currentVersion, forKey: "currentVersion")
        dict.setObject(self.lastRefresh, forKey: "lastRefresh")
        dict.setObject(self.headVersion, forKey: "headVersion")
        dict.setObject(self.creationDate, forKey: "creationDate")
        dict.setObject(self.updateAvailable, forKey: "updateAvailable")
        dict.setObject("Wordpress", forKey: "type")
        
        let fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path)))
        {
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
        return dict.writeToFile(path, atomically: true)
    }
    
    func updateDate() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        self.lastRefresh = dateFormatter.stringFromDate(NSDate())
    }
    
    func getVersions() -> Bool {
        let headVersion = self.getInstanceVersionJSON(wordpressAPIUrl)
        let currentVersion = self.getInstanceVersion(self.hosturl)
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    func checkNotificationRequired() {
        if(!(self.headVersion == self.currentVersion) && (self.updateAvailable == 0)) {
            self.updateAvailable = 1
            incrementBadgeNumber()
            sendNotification("Newer version available", informativeText: "Please update your \(self.name) instance")
        } else if((self.headVersion == self.currentVersion) && (self.updateAvailable == 1)) {
            self.updateAvailable = 0
            decrementBadgeNumber()
        } else {
            self.updateAvailable = 0
        }
    }
    
    func getInstanceVersion(url: String) -> String {
        if(url != "") {
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