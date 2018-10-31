//
//  SectionFeature.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension SettingViewController {
    enum Section: Int, CaseIterable {
        case account = 0
        case information
        case support
        case logout
        
        var sectionString: String {
            switch self {
            case .account: return "Account"
            case .information: return "Information"
            case .support: return "Support"
            case .logout: return "Logout"
            
            }
        }
    }
}

// Section 1
extension SettingViewController {
    enum Account: String, CaseIterable {
        case profile_setting = "Profile Settings"
    }
}

// Section 2
extension SettingViewController {
    enum Information: String, CaseIterable {
        case app_version = "App Version"
        case opensource_license = "Open-Source License"
    }
}

// Section 3
extension SettingViewController {
    enum Support: String, CaseIterable {
        case feedback = "FeedBack"
    }
}

// Section 4
extension SettingViewController {
    enum Logout: String, CaseIterable {
        case logout = "Logout"
    }
}