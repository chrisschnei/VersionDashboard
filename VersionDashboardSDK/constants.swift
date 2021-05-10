//
//  constants.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 11.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

/**
 Constants class holds app global values.
 */
public class Constants {
    public static var appurl = ""
    public static var applicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
    public static var applicationSupportAppname = applicationSupportPath + "/Version Dashboard"
    public static var plistFilesPath = applicationSupportAppname + "/config/"
    public static var headPlistFilesPath = applicationSupportAppname + "/head/"
    
    public static var contentsResources = ""
    
    public static var timerInterval = 5
    
    public static var appBundleConfigationPath = appurl + contentsResources + "configuration.plist"
    public static var configurationFilePath = applicationSupportAppname + "/configuration.plist"
    
    public static var appBundleJoomlaPath = appurl + contentsResources + "joomla.plist"
    public static var appBundlewordpressPath = appurl + contentsResources + "wordpress.plist"
    public static var appBundleOwncloudPath = appurl + contentsResources + "owncloud.plist"
    public static var appBundlePiwikPath = appurl + contentsResources + "piwik.plist"
    public static var appBundleNexcloudPath = appurl + contentsResources + "nextcloud.plist"
    public static let joomlaHead = "joomla.plist"
    public static var joomlaFilePath = headPlistFilesPath + joomlaHead
    public static let wordpressHead = "wordpress.plist"
    public static var wordpressFilePath = headPlistFilesPath + wordpressHead
    public static let owncloudHead = "owncloud.plist"
    public static var owncloudFilePath = headPlistFilesPath + owncloudHead
    public static let nextcloudHead = "nextcloud.plist"
    public static var nextcloudFilePath = headPlistFilesPath + nextcloudHead
    public static let piwikHead = "piwik.plist"
    public static var piwikFilePath = headPlistFilesPath + piwikHead
    
    public static var dateformat = "dd-MM-yyyy"
    
    public static var joomlapath = String()
    public static var joomlaAPIUrl = String()
    public static var joomlaBackendURL = String()
    
    public static var wordpressAPIUrl = String()
    public static var wordpressBackendURL = String()
    
    public static var piwikAPIUrl = String()
    public static var piwikLatestVersionURL = String()
    
    public static var owncloudAPIUrl = String()
    public static var owncloudStatusFile = String()
    public static var owncloudRegexDownload = String()
    
    public static var nextcloudAPIUrl = String()
    public static var nextcloudStatusFile = String()
    public static var nextcloudRegexDownload = String()
    
    public static var refreshIntervals = Array<String>()
    
    public static var refreshHeadInstances = Int()
    
    public static var timer: Timer = Timer()
    
    /**
     Initializes Constants class.
     
     - Parameters:
     - appurlParam: Dynamic URL to application bundle
     */
    public static func initialize(_ appurlParam : String) {
        appurl = appurlParam
        #if os(OSX)
            contentsResources = "/Contents/Resources/"
        #else
            contentsResources = "/"
        #endif
        
        appBundleJoomlaPath = appurl + contentsResources + "joomla.plist"
        appBundlewordpressPath = appurl + contentsResources + "wordpress.plist"
        appBundleOwncloudPath = appurl + contentsResources + "owncloud.plist"
        appBundlePiwikPath = appurl + contentsResources + "piwik.plist"
        appBundleNexcloudPath = appurl + contentsResources + "nextcloud.plist"
        
        joomlaFilePath = headPlistFilesPath + joomlaHead
        wordpressFilePath = headPlistFilesPath + wordpressHead
        owncloudFilePath = headPlistFilesPath + owncloudHead
        nextcloudFilePath = headPlistFilesPath + nextcloudHead
        piwikFilePath = headPlistFilesPath + piwikHead
        
        dateformat = "dd-MM-yyyy"
        
        joomlapath = "administrator/manifests/files/joomla.xml"
        joomlaAPIUrl = "https://downloads.joomla.org/cms/joomla3"
        joomlaBackendURL = "administrator/"
        
        wordpressAPIUrl = "http://api.wordpress.org/core/version-check/1.7/"
        wordpressBackendURL = "wp-admin/"
        
        piwikAPIUrl = "index.php?module=API&method=API.getPiwikVersion&token_auth="
        piwikLatestVersionURL = "https://api.piwik.org/1.0/getLatestVersion/"
        
        owncloudAPIUrl = "https://demo.owncloud.org/"
        owncloudStatusFile = "status.php"
        owncloudRegexDownload = "https:[/]*download.owncloud.org/community/owncloud[0-9a-zA-Z-.]*zip"
        
        nextcloudAPIUrl = "https://nextcloud.com/"
        nextcloudStatusFile = "changelog"
        nextcloudRegexDownload = "https:[/]*download.nextcloud.com/server/releases/nextcloud-[0-9a-zA-Z-.]*zip"
        
        refreshIntervals = ["6", "12", "24", "48"]
        
        /* 3h */
        refreshHeadInstances = 10800
        
        timer = Timer()
    }
}
