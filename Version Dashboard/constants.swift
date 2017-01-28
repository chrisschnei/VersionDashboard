//
//  constants.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 11.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

let appurl = Bundle.main.bundlePath
let applicationSupportURL = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
let applicationSupportAppNameURL = applicationSupportURL[0] + "/Version Dashboard"
let plistFilesPath = applicationSupportURL[0] + "/Version Dashboard/config/"
let configurationFilePath = applicationSupportAppNameURL + "/configuration.plist"
let appBundleConfigurationPath = appurl + "/Contents/Resources/configuration.plist"

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

let typo3JSONUrl = "https://get.typo3.org/json"

let refreshIntervals = ["6", "12", "24", "48"]

var timer: Timer = Timer()
