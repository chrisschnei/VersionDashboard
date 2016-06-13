//
//  constants.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 11.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

let appurl = NSBundle.mainBundle().bundlePath
let applicationSupportURL = NSSearchPathForDirectoriesInDomains(.ApplicationSupportDirectory, .UserDomainMask, true)
let applicationSupportAppNameURL = applicationSupportURL[0].stringByAppendingString("/Version Dashboard")
let plistFilesPath = applicationSupportURL[0].stringByAppendingString("/Version Dashboard/config/")
let configurationFilePath = applicationSupportAppNameURL.stringByAppendingString("/configuration.plist")
let appBundleConfigurationPath = appurl.stringByAppendingString("/Contents/Resources/configuration.plist")

let dateformat = "dd-MM-yyyy"

let joomlapath = "administrator/manifests/files/joomla.xml"
let joomlaAPIUrl = "https://www.joomla.org/"
let joomlaBackendURL = "administrator/"

let wordpressAPIUrl = "http://api.wordpress.org/core/version-check/1.7/"
let wordpressIndexPath = ""
let wordpressBackendURL = "wp-admin/"

let piwikAPIUrl = "index.php?module=API&method=API.getPiwikVersion&token_auth="
let piwikLatestVersionURL = "https://api.piwik.org/1.0/getLatestVersion/"

let owncloudAPIUrl = "https://owncloud.org/install/#instructions-server"
let owncloudStatusFile = "status.php"

let typo3JSONUrl = "https://get.typo3.org/json"

let refreshIntervals = ["6", "12", "24", "48"]

var timer: NSTimer = NSTimer()