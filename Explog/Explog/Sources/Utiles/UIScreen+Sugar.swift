//
//  UIScreen+sugar.swift
//  Explog
//
//  Created by minjuniMac on 09/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UIScreen {
    static var mainSize: CGSize {
        return UIScreen.main.bounds.size
    }
    static var mainWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    static var mainHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    static var mainbounds: CGRect {
        return UIScreen.main.bounds
    }
    
}


