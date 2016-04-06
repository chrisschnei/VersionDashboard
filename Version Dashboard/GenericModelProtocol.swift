//
//  GenericModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

protocol GenericModelProtocol {
    
    func saveConfigfile() -> Bool
    func updateDate()
    func renamePlistFile(oldName: String)
    func checkNotificationRequired()
    func phpVersionRequest(completionHandler: ((NSURLResponse!) -> Void)?)
    func phpReturnHandler(data: NSURLResponse!)
    
}