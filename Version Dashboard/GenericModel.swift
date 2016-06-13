//
//  GenericModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.04.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class GenericModel: GenericModelProtocol {
    
    var hosturl = String()
    var currentVersion = String()
    var lastRefresh = String()
    var headVersion = String()
    var creationDate = String()
    var updateAvailable = Int()
    var name = String()
    var type = String()
    var phpVersion = String()
    var serverType = String()
    
    init(creationDate: String, currentVersion: String, hosturl: String, lastRefresh: String, name: String, type: String, headVersion: String, updateAvailable: Int, phpVersion: String, serverType: String) {
        self.hosturl = hosturl
        self.currentVersion = currentVersion
        self.lastRefresh = lastRefresh
        self.headVersion = headVersion
        self.creationDate = creationDate
        self.name = name
        self.updateAvailable = updateAvailable
        self.type = type
        self.phpVersion = phpVersion
        self.serverType = serverType
    }

    func renamePlistFile(oldName: String) {
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.moveItemAtPath(plistFilesPath.stringByAppendingString(oldName).stringByAppendingString(".plist"), toPath: plistFilesPath.stringByAppendingString(self.name).stringByAppendingString(".plist"))
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    func saveConfigfile() -> Bool {
        let path = plistFilesPath.stringByAppendingString(self.name).stringByAppendingString(".plist")
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
        dict.setObject(self.phpVersion, forKey: "phpVersion")
        dict.setObject(self.serverType, forKey: "serverType")
        dict.setObject(self.type, forKey: "type")
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

    func phpReturnHandler(data: NSURLResponse!) {
        let lines = (String(data!)).componentsSeparatedByString("\n")
        if(lines.count > 0) {
            for line in lines {
                if(line.rangeOfString("X-Powered-By") != nil) {
                    let phpArray = line.componentsSeparatedByString("=")
                    let phpString = phpArray[1].componentsSeparatedByString("PHP/")
                    let number = phpString[1].componentsSeparatedByString("\"")[0]
                    self.phpVersion = number
                }
                if(line.rangeOfString("Server") != nil) {
                    let phpArray = line.componentsSeparatedByString("=")
                    let phpString = phpArray[1].componentsSeparatedByString("\"")
                    if(phpString.indices.contains(1)) {
                        let server = phpString[1].componentsSeparatedByString("\"")[0]
                        self.serverType = server
                    } else {
                        self.serverType = ""
                    }
                }
            }
        } else {
            self.phpVersion = ""
            self.serverType = ""
        }
    }
    
    func phpVersionRequest(completionHandler: ((NSURLResponse!) -> Void)?)
    {
        let semaphore = dispatch_semaphore_create(0)
        let url : NSURL! = NSURL(string:self.hosturl)
        let request: NSURLRequest = NSURLRequest(URL:url)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            completionHandler?(response);
            dispatch_semaphore_signal(semaphore)
        });
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
    }
    
}
