//
//  JoomlaModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class JoomlaModel : GenericModel, XMLParserDelegate {
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
        self.name = name
        self.updateAvailable = updateAvailable
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
        dict.setObject("Joomla", forKey: "type")
        
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
        let headVersion = self.getInstanceVersion(joomlaAPIUrl.stringByAppendingString(joomlapath))
        let currentVersion = self.getInstanceVersion((self.hosturl).stringByAppendingString(joomlapath))
        if(headVersion != "" && currentVersion != "") {
            self.headVersion = headVersion
            self.currentVersion = currentVersion
            return true
        }
        return false
    }
    
    func checkNotificationRequired() {
        if((self.headVersion != self.currentVersion) && (self.updateAvailable == 0)) {
            self.updateAvailable = 1
            incrementBadgeNumber()
            sendNotification(NSLocalizedString("newerVersion", comment: ""), informativeText: (String.localizedStringWithFormat(NSLocalizedString("pleaseUpdate", comment: ""), self.name)))
        } else if((self.headVersion == self.currentVersion) && (self.updateAvailable == 1)) {
            self.updateAvailable = 0
            decrementBadgeNumber()
        }
    }
    
    func XMLParserError(parser: XMLParser, error: String) {
        print(error);
    }
    
    func getInstanceVersion(url: String) -> String {
        let pathToXml = NSURL(string: url)
        let parser = XMLParser(url: pathToXml!);
        
        parser.delegate = self;
        let s = parser.parse {
        }
        return s
    }
}
