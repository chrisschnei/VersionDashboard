//
//  GenericHeadModelProtocol.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

protocol GenericHeadModelProtocol {
    
    func saveConfigfile(filename: String) -> Bool
    func updateDate()
    func renamePlistFile(_ oldName: String)
    
}
