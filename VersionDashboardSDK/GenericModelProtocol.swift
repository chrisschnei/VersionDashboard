//
//  GenericModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

public protocol GenericModelProtocol {
    
    /**
     Save object to config plist file.
     
     - Returns: true on success, false on failure
     */
    func saveConfigfile() -> Bool
    
    /**
     Get version from custom joomla instance server.
     
     - Parameters:
     - forceUpdate: true to retrieve version string and ignore time interval, false if time interval should be respected.
     - Returns: true if version string download succeeded, false on error
     */
    func getVersions(forceUpdate: Bool) -> Bool
    
    /**
     Updates date on given object.
     */
    func updateDate()
    
    /**
     Rename plist file. Specified name will be moved to name class attribute
     
     - Parameters:
     - oldName: contains old filename.
     - Returns: true if file is moved successfully or false on failure
     */
    func renamePlistFile(_ oldName: String) -> Bool
    
    /**
     Checks if webservice is outdated and user notification should be displayed.
     In case of outdated version updateAvailable attribute is set to 1.
     
     - Returns: true in case of update is available, false if instance is up to date
     */
    func checkNotificationRequired() -> Bool
    
    /**
     Function for getting php version string out of HTTP header.
     
     - Parameters:
     - completionHandler: Function for downloading data via HTTP request
     */
    func phpVersionRequest(_ completionHandler: ((URLResponse?) -> Void)?)
    
    /**
     Return handler function for extracting PHP version string from HTTP header.
     
     - Parameters:
     - data: HTTP header data to be filtered
     - Returns: void
     */
    func phpReturnHandler(_ data: URLResponse?) -> Void
}
