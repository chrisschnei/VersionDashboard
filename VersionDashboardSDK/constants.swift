//
//  constants.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 11.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

public class Constants {
    public static let appurl = Bundle.main.bundlePath
    public static let applicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
    public static let applicationSupportAppname = applicationSupportPath + "/Version Dashboard"
    public static let plistFilesPath = applicationSupportAppname + "/config/"
    public static let headPlistFilesPath = applicationSupportAppname + "/head/"
    
    public static let appBundleConfigationPath = appurl + "/Contents/Resources/configuration.plist"
    public static let configurationFilePath = applicationSupportAppname + "/configuration.plist"
    
    public static let appBundleJoomlaPath = appurl + "/Contents/Resources/joomla.plist"
    public static let appBundlewordpressPath = appurl + "/Contents/Resources/wordpress.plist"
    public static let appBundleOwncloudPath = appurl + "/Contents/Resources/owncloud.plist"
    public static let appBundlePiwikPath = appurl + "/Contents/Resources/piwik.plist"
    public static let joomlaHead = "joomla.plist"
    public static let joomlaFilePath = headPlistFilesPath + joomlaHead
    public static let wordpressHead = "wordpress.plist"
    public static let wordpressFilePath = headPlistFilesPath + wordpressHead
    public static let owncloudHead = "owncloud.plist"
    public static let owncloudFilePath = headPlistFilesPath + owncloudHead
    public static let piwikHead = "piwik.plist"
    public static let piwikFilePath = headPlistFilesPath + piwikHead
    
    public static let dateformat = "dd-MM-yyyy"
    
    public static let joomlapath = "administrator/manifests/files/joomla.xml"
    public static let joomlaAPIUrl = "https://www.joomla.org/"
    public static let joomlaBackendURL = "administrator/"
    
    public static let wordpressAPIUrl = "http://api.wordpress.org/core/version-check/1.7/"
    public static let wordpressIndexPath = ""
    public static let wordpressBackendURL = "wp-admin/"
    
    public static let piwikAPIUrl = "index.php?module=API&method=API.getPiwikVersion&token_auth="
    public static let piwikLatestVersionURL = "https://api.piwik.org/1.0/getLatestVersion/"
    
    public static let owncloudAPIUrl = "https://owncloud.org/install/#edition"
    public static let owncloudStatusFile = "status.php"
    
    public static let refreshIntervals = ["6", "12", "24", "48"]
    
    /* 3h */
    public static let refreshHeadInstances = 10800
    
    public static var timer: Timer = Timer()
}
