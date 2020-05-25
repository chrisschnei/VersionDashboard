//
//  imageResize.swift
//  VersionDashboardiOS
//
//  Created by Christian Schneider on 25.05.20.
//  Copyright © 2020 NonameCompany. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
