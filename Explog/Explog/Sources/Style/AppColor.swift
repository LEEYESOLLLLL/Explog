//
//  AppColor.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

public enum StyleColor {
    case defaultColor
    
    var adepted: UIColor {
        switch self {
        case .defaultColor:
            return UIColor(red:0.36, green:0.63, blue:0.95, alpha:1.00)
        }
    }
}
