//
//  InstanceRepository.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 11.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

public class SystemInstances {
    static public var systemInstances = Dictionary<String, AnyObject>()
}

public class HeadInstances {
    static public var headInstances = Dictionary<String, AnyObject>()
}

public class OutdatedInstances {
    static public var outdatedInstances : [String] = []
}

public class ConfigurationSettings {
    static public var configurationSettings = Dictionary<String, Any>()
}
