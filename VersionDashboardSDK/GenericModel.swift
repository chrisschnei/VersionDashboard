//
//  GenericModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 03.04.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

/**
 GenericModel class for instantiating specific webservice models.
 */
open class GenericModel: GenericModelProtocol {
    
    /**
     Variable hosturl for storing url to webservice.
     */
    public var hosturl = String()
    
    /**
     Variable currentVersion contains webservice version.
     */
    public var currentVersion = String()
    
    /**
     Variable headVersion contains webservice vendor version.
     */
    public var headVersion = String()
    
    /**
     Variable lastRefresh contains last update timestamp.
     */
    public var lastRefresh = String()
    
    /**
     Variable creationDate holds webservice creation date.
     */
    public var creationDate = String()
    
    /**
     Variable updateAvailable decides whether webservice should be updated.
     */
    public var updateAvailable = Int()
    
    /**
     Variable name of instance.
     */
    public var name = String()
    
    /**
     Variable type contains webservice type.
     */
    public var type = String()
    
    /**
     Variable phpVersion contains php version supplied by http header.
     */
    public var phpVersion = String()
    
    /**
     Variable serverType contains webserver type supplied by http header.
     */
    public var serverType = String()
    
    /**
     Initializes a new webservice model.
     
     - Parameters:
     - creationDate: timestamp of webservice
     - currentVersion: version of self hosted webservice
     - hosturl: url to self hosted webservice
     - headVersion: version of webservice supplied by vendor
     - lastRefresh: timestamp of last update
     - name: webservice name
     - type: type of webservice
     - updateAvailable: signals if webservice update is available
     - phpVersion: contains active php version
     - serverType: contains webserver type
     */
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

    /**
     Rename plist file. Specified name will be moved to name class attribute
     
     - Parameters:
     - oldName: contains old filename.
     - Returns: true if file is moved successfully or false on failure
     */
    open func renamePlistFile(_ oldName: String) -> Bool {
        let fileManager = FileManager.default
        do {
            try fileManager.moveItem(atPath: (Constants.plistFilesPath + oldName) + ".plist", toPath: (Constants.plistFilesPath + self.name) + ".plist")
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
            return false
        }
        return true
    }
    
    /**
     Saves a config file to disc.
     
     - Parameters:
     - filename: String containing file location
     - Returns: true if file is written successfully or false on failure
     */
    open func saveConfigfile() -> Bool {
        let path = (Constants.plistFilesPath + self.name) + ".plist"
        let dict: NSMutableDictionary = NSMutableDictionary()
        
        if(self.creationDate == "") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = Constants.dateformat
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
    
    /**
     Deletes a plist file from database directory.
     
     - Parameters:
     - filename: String containing filename to be deleted.
     - Returns: true if file is deleted successfully or false on failure
     */
    public static func deleteFile(_ filename: String) {
        let path = (Constants.plistFilesPath + filename) + ".plist"
        
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch let error as NSError {
            print("Error deleting plist file: \(error)")
        }
    }
    
    /**
     Updates lastRefresh attribute in object.
     */
    open func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.lastRefresh = dateFormatter.string(from: Date())
    }
    
    /**
     Checks if webservice is outdated and user notification should be displayed.
     In case of outdated version updateAvailable attribute is set to 1.
     */
    open func checkNotificationRequired() {
        if (self.headVersion == "0.0" || self.currentVersion == "0.0") {
        } else if((self.headVersion > self.currentVersion) && (self.updateAvailable == 0)) {
            self.updateAvailable = 1
        } else if((self.headVersion == self.currentVersion) && (self.updateAvailable == 1)) {
            self.updateAvailable = 0
        }
    }

    /**
     Return handler function for extracting PHP version string from HTTP header.
     
     - Parameters:
     - data: HTTP header data to be filtered
     - Returns: void
     */
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
    
    /**
     Function for getting php version string out of HTTP header.
     
     - Parameters:
     - completionHandler: Function for downloading data via HTTP request
     */
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
    
    /**
     Get version from custom joomla instance server.
     
     - Parameters:
     - forceUpdate: true to retrieve version string and ignore time interval, false if time interval should be respected.
     - Returns: true if version string download succeeded, false on error
     */
    public func getVersions(forceUpdate: Bool) -> Bool {
        print("Call this function on a specific object instance type")
        return false
    }
    
}
