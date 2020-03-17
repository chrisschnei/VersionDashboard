//
//  GenericHeadModelProtocol.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

/**
 GenericHeadModelProtocol.
 Implements mandatory functions in GenericHeadModel instances.
 */
public protocol GenericHeadModelProtocol {
   
    /**
     Saves a config file to disc.
     
     - Parameters:
     - filename: String containing file location
     - Returns: true if file is written successfully or false on failure
     */
    func saveConfigfile(filename: String) -> Bool
    
    /**
     Update timestamp of refreshDate attribute.
     */
    func updateDate()
    
    /**
     Replace plist file.
     
     - Parameters:
     - filename: String containing old filename
     - Returns: true if file is replaced successfully or false on failure
     */
    func renamePlistFile(_ oldName: String) -> Bool
    
    /**
     Get version from vendor server.
     
     - Parameters:
     - forceUpdate: true if time checks should be ignored and version should be updated immediately, false to only retrieve version when time interval is exceeded.
     - Returns: true if download succeeded, false in error case
     */
    func updateHeadObject(forceUpdate: Bool) -> Bool
}
