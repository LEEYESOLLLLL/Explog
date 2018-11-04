//
//  UIBarButton+BackgroundImage.swift
//  Explog
//
//  Created by minjuniMac on 03/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    func setBackgroundImage(normal nImage: UIImage, highlighted hImage: UIImage) {
        setBackgroundImage(nImage, for: .normal, style: .plain, barMetrics: .default)
        setBackgroundImage(hImage, for: .highlighted, style: .plain, barMetrics: .default)
    }
}
