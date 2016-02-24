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
let wordpressAPIUrl = ""
let wordpressIndexPath = ""
let piwikAPIUrl = "index.php?module=API&method=API.getPiwikVersion&token_auth="
let piwikLatestVersionURL = "https://api.piwik.org/1.0/getLatestVersion/"
let owncloudAPIUrl = "https://demo.owncloud.org/"
let owncloudVersionURL = "index.php/core/js/oc.js"

/*https://asana24.net/piwik/index.php?module=API&method=API.getPiwikVersion&token_auth=2d23a0d2ae3951274ab64561227b6703*/