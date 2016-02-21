//
//  OwncloudModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

class OwncloudModel : GenericModel {
    var hosturl = String()
    var currentVersion = String()
    var lastRefresh = String()
    var headVersion = String()
    var creationDate = String()
    var name = String()
    var type = String()
    
    init(creationDate: String, currentVersion: String, hosturl: String, lastRefresh: String, name: String, type: String, headVersion: String) {
        self.hosturl = hosturl
        self.currentVersion = currentVersion
        self.lastRefresh = lastRefresh
        self.headVersion = headVersion
        self.creationDate = creationDate
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
        dict.setObject("Owncloud", forKey: "type")
        
        let fileManager = NSFileManager.defaultManager()
        if (!(fileManager.fileExistsAtPath(path)))
        {
            fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        }
        return dict.writeToFile(path, atomically: true)
    }
    
    func loadConfigfile() -> Bool {
        let path = NSBundle.mainBundle().pathForResource("config/Joomla", ofType: "plist")
        let myDict = NSDictionary(contentsOfFile: path!)
        if (myDict != nil) {
            self.hosturl = myDict!.valueForKey("hosturl")! as! String
            self.currentVersion = myDict!.valueForKey("currentVersion")! as! String
            self.lastRefresh = myDict!.valueForKey("lastRefresh")! as! String
            self.headVersion = myDict!.valueForKey("headVersion")! as! String
            return true
        } else {
            print("WARNING: Couldn't load dictionary from plist file!")
            return false
        }
    }
    
    func getInstanceVersion(url: String) -> String {
        let semaphore = dispatch_semaphore_create(0)
        let url = NSURL(string: url)
        var version = ""
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let body = (NSString(data: data!, encoding: NSUTF8StringEncoding))
            let lines = body?.componentsSeparatedByString("\n")
            for part in lines! {
                if(part.rangeOfString("versionstring") != nil) {
                    let part2 = part.componentsSeparatedByString(",")
                    for element in part2 {
                        if((element.rangeOfString("versionstring")) != nil) {
                            let element2 = element.componentsSeparatedByString(":")
                            version = (element2[1].stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
                            dispatch_semaphore_signal(semaphore)
                        }
                    }
                }
                }
            })
        }
        task.resume()
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
        return version
    }

}