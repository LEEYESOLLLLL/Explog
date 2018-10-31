//
//  UINavigationController+Transpar.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UINavigationController {
    func transparentNaviBar(_ is: Bool, navigationBarHidden: Bool = false ) {
        setNavigationBarHidden(navigationBarHidden, animated: false)
        navigationBar.setBackgroundImage(`is` ? UIImage() : nil, for: .default)
        navigationBar.shadowImage = `is` ? UIImage() : nil
        navigationBar.isTranslucent = `is`
    }
}

