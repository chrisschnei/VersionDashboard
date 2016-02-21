//
//  GenericModel.swift
//  Version Dashboard
//
//  Created by Christian Schneider on 10.02.16.
//  Copyright © 2016 NonameCompany. All rights reserved.
//

import Foundation

protocol GenericModel {
    
    func saveConfigfile() -> Bool
    func loadConfigfile() -> Bool

}