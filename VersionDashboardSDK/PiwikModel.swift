//
//  PiwikModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

open class PiwikModel : GenericModel, XMLParserDelegate {
    
    /**
     Variable holds instance specific API token neede for REST webservice authentication.
     */
    open var apiToken = String()
    
    /**
     Contains piwik instance version.
     */
    open var version = String()
    
    /**
     Constructor for creating new piwik instance instances.
     */
    public init(creationDate: String, currentVersion: String, hosturl: String, apiToken: String, lastRefresh: String, name: String, type: String, headVersion: String, updateAvailable: Int, phpVersion: String, serverType: String) {
        super.init(creationDate: creationDate, currentVersion: currentVersion, hosturl: hosturl, headVersion: headVersion, lastRefresh: lastRefresh, name: name, type: type, updateAvailable: updateAvailable, phpVersion: phpVersion, serverType: serverType)
        self.apiToken = apiToken
    }
    
    /**
     Get version from custom joomla instance server.
     
     - Parameters:
     - forceUpdate: true to retrieve version string and ignore time interval, false if time interval should be respected.
     - Returns: true if version string download succeeded, false on error
     */
    open override func getVersions(forceUpdate: Bool) -> Bool {
        let piwikheadobject = HeadInstances.headInstances["Piwik"] as! PiwikHeadModel
        if (!piwikheadobject.getVersion(forceUpdate: forceUpdate)) {
            print("Could not get piwik head version. Abort further checking.")
            return false
        }
        let currentVersion = self.getInstanceVersionXML(((self.hosturl) + Constants.piwikAPIUrl) + self.apiToken)
        self.phpVersionRequest(self.phpReturnHandler)
        if(!currentVersion.isEmpty) {
            self.currentVersion = currentVersion
            self.headVersion = piwikheadobject.headVersion
            return true
        }
        
        self.currentVersion = "0.0"
        self.headVersion = "0.0"
        return false
    }
    
    /**
     Saves a config file to disc.
     
     - Parameters:
     - filename: String containing file location
     - Returns: true if file is written successfully or false on failure
     */
    override open func saveConfigfile() -> Bool {
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
        dict.setObject(self.lastRefresh, forKey: "lastRefresh" as NSCopying)
        dict.setObject(self.creationDate, forKey: "creationDate" as NSCopying)
        dict.setObject(self.apiToken, forKey: "apiToken" as NSCopying)
        dict.setObject(self.updateAvailable, forKey: "updateAvailable" as NSCopying)
        dict.setObject(self.phpVersion, forKey: "phpVersion" as NSCopying)
        dict.setObject(self.serverType, forKey: "serverType" as NSCopying)
        dict.setObject("Piwik", forKey: "type" as NSCopying)
        
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            fileManager.createFile(atPath: path, contents: nil, attributes: nil)
        }
        return dict.write(toFile: path, atomically: true)
    }
    
    /**
     Get version from joomla vendor server.
     
     - Parameters:
     - url: URL to joomla vendor version string page.
     - Returns: String containing version number
     */
    func getInstanceVersion(_ url: String) -> String {
        if let version = try? Data(contentsOf: URL(string: url)!) {
            let version = String(data: version, encoding: String.Encoding.utf8)
            return version!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        return ""
    }
    
    /**
     Called on XML parser error.
     
     - Parameters:
     - parser: XML parser object
     - error: String with contains error details
     */
    func XMLParserError(_ parser: XMLParser, error: String) {
        print(error);
    }
    
    /**
     Get version from piwik vendor server.
     
     - Parameters:
     - url: URL to piwik instance version string page.
     - Returns: String containing version number
     */
    func getInstanceVersionXML(_ url: String) -> String {
        let pathToXml = URL(string: url)
        let parser = VersionDashboardXMLParser(url: pathToXml!);
        if (!parser.startParsing()) {
            print("Error extracting piwik version string.")
        }
        return parser.version
    }
    
}
