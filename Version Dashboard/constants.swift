//
//  constants.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 11.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

let appurl = NSBundle.mainBundle().bundlePath.stringByAppendingString("/Contents/Resources/config/")

let dateformat = "dd-MM-yyyy"

let joomlapath = "administrator/manifests/files/joomla.xml"
let joomlaAPIUrl = "https://www.joomla.org/"
let joomlaBackendURL = "administrator/"

let wordpressAPIUrl = "http://api.wordpress.org/core/version-check/1.7/"
let wordpressIndexPath = ""
let wordpressBackendURL = "wp-admin/"

let piwikAPIUrl = "index.php?module=API&method=API.getPiwikVersion&token_auth="
let piwikLatestVersionURL = "https://api.piwik.org/1.0/getLatestVersion/"

let owncloudAPIUrl = "https://demo.owncloud.org/"
let owncloudVersionURL = "index.php/core/js/oc.js"

let configurationFilePath = NSBundle.mainBundle().pathForResource("configuration", ofType: "plist")
let refreshIntervals = ["6", "12", "24", "48"]

var timer: NSTimer = NSTimer()