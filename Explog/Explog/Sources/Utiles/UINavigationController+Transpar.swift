//
//  UINavigationController+Transpar.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UINavigationController {
    func transparentNaviBar() {
        setNavigationBarHidden(false, animated: false)
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }
}
