//
//  GenericModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.04.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class GenericModel: GenericModelProtocol {
    
    public var hosturl = String()
    public var currentVersion = String()
    public var headVersion = String()
    public var lastRefresh = String()
    public var creationDate = String()
    public var updateAvailable = Int()
    public var name = String()
    public var type = String()
    public var phpVersion = String()
    public var serverType = String()
    
    public init(creationDate: String, currentVersion: String, hosturl: String, headVersion: String, lastRefresh: String, name: String, type: String, updateAvailable: Int, phpVersion: String, serverType: String) {
        self.hosturl = hosturl
        self.currentVersion = currentVersion
        self.headVersion = headVersion
        self.lastRefresh = lastRefresh
        self.creationDate = creationDate
        self.name = name
        self.updateAvailable = updateAvailable
        self.type = type
        self.phpVersion = phpVersion
        self.serverType = serverType
    }

    open func renamePlistFile(_ oldName: String) {
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: (plistFilesPath + oldName) + ".plist", toPath: (plistFilesPath + self.name) + ".plist")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
    
    public func saveConfigfile() -> Bool {
        let path = (plistFilesPath + self.name) + ".plist"
        let dict: NSMutableDictionary = NSMutableDictionary()
        
        if(self.creationDate == "") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateformat
            self.creationDate = dateFormatter.string(from: Date())
        }
        dict.setObject(self.hosturl, forKey: "hosturl" as NSCopying)
        dict.setObject(self.name, forKey: "name" as NSCopying)
        dict.setObject(self.currentVersion, forKey: "currentVersion" as NSCopying)
        dict.setObject(self.headVersion, forKey: "headVersion" as NSCopying)
        dict.setObject(self.lastRefresh, forKey: "lastRefresh" as NSCopying)
        dict.setObject(self.creationDate, forKey: "creationDate" as NSCopying)
        dict.setObject(self.updateAvailable, forKey: "updateAvailable" as NSCopying)
        dict.setObject(self.phpVersion, forKey: "phpVersion" as NSCopying)
        dict.setObject(self.serverType, forKey: "serverType" as NSCopying)
        dict.setObject(self.type, forKey: "type" as NSCopying)
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return dict.write(toFile: path, atomically: true)
    }
    
    open func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.lastRefresh = dateFormatter.string(from: Date())
    }
    
    open func checkNotificationRequired() {
        if (self.headVersion == "0.0" || self.currentVersion == "0.0") {
        } else if((self.headVersion > self.currentVersion) && (self.updateAvailable == 0)) {
            self.updateAvailable = 1
        } else if((self.headVersion == self.currentVersion) && (self.updateAvailable == 1)) {
            self.updateAvailable = 0
        }
    }

    open func phpReturnHandler(_ data: URLResponse?) -> Void {
        let lines = (String(describing: data)).components(separatedBy: "\n")
        if(lines.count > 0) {
            for line in lines {
                if(line.range(of: "PHP/") != nil) {
                    let phpString = line.components(separatedBy: "PHP/")
                    let number = phpString[1].components(separatedBy: "\"")[0]
                    self.phpVersion = number
                }
                if(line.range(of: "Apache") != nil || line.range(of: "nginx") != nil) {
                    if(line != "") {
                        self.serverType = line.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "\"", with: "")
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
    
    open func phpVersionRequest(_ completionHandler: ((URLResponse?) -> Void)?)
    {
        let semaphore = DispatchSemaphore(value: 0)
        let url : URL! = URL(string:self.hosturl)
        let request: URLRequest = URLRequest(url:url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
            completionHandler?(response);
            semaphore.signal()
        });
        task.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
}
