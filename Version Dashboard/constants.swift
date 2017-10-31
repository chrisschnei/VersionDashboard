//
//  constants.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 11.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

let appurl = Bundle.main.bundlePath
let applicationSupportPath = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
let applicationSupportAppname = applicationSupportPath + "/Version Dashboard"
let plistFilesPath = applicationSupportAppname + "/config/"
let headPlistFilesPath = applicationSupportAppname + "/head/"

let appBundleConfigationPath = appurl + "/Contents/Resources/configuration.plist"
let configurationFilePath = applicationSupportAppname + "/configuration.plist"

let appBundleJoomlaPath = appurl + "/Contents/Resources/joomla.plist"
let appBundlewordpressPath = appurl + "/Contents/Resources/wordpress.plist"
let appBundleOwncloudPath = appurl + "/Contents/Resources/owncloud.plist"
let appBundlePiwikPath = appurl + "/Contents/Resources/piwik.plist"
let joomlaHead = "joomla.plist"
let joomlaFilePath = headPlistFilesPath + joomlaHead
let wordpressHead = "wordpress.plist"
let wordpressFilePath = headPlistFilesPath + wordpressHead
let owncloudHead = "owncloud.plist"
let owncloudFilePath = headPlistFilesPath + owncloudHead
let piwikHead = "piwik.plist"
let piwikFilePath = headPlistFilesPath + piwikHead

let dateformat = "dd-MM-yyyy"

let joomlapath = "administrator/manifests/files/joomla.xml"
let joomlaAPIUrl = "https://www.joomla.org/"
let joomlaBackendURL = "administrator/"

let wordpressAPIUrl = "http://api.wordpress.org/core/version-check/1.7/"
let wordpressIndexPath = ""
let wordpressBackendURL = "wp-admin/"

let piwikAPIUrl = "index.php?module=API&method=API.getPiwikVersion&token_auth="
let piwikLatestVersionURL = "https://api.piwik.org/1.0/getLatestVersion/"

let owncloudAPIUrl = "https://owncloud.org/install/#edition"
let owncloudStatusFile = "status.php"

let refreshIntervals = ["6", "12", "24", "48"]

let refreshHeadInstances = 10800

var timer: Timer = Timer()
