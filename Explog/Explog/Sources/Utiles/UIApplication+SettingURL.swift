//
//  UIApplication+SettingURL.swift
//  Explog
//
//  Created by minjuniMac on 08/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UIApplication {
    func openSettings() {
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        self.open(settingURL, options: [:], completionHandler: nil)
    }
}
