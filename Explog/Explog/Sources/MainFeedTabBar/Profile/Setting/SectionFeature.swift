//
//  SectionFeature.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Localize_Swift
extension SettingViewController {
    enum Section: Int, CaseIterable {
        case account = 0
        case feature
        case information
        case support
        case logout
        
        var sectionLocalizedString: String {
            switch self {
            case .account:     return "Account".localized()
            case .feature:     return "Feature".localized()
            case .information: return "Information".localized()
            case .support:     return "Support".localized()
            case .logout:      return "Logout".localized()
            }
        }
    }
}

// Section 1
extension SettingViewController {
    enum Account: String, CaseIterable {
        case profile_setting = "Profile Settings"
        case change_password = "Change Password"
        
        var localizedString: String {
            return self.rawValue.localized()
        }
        
        init?(byLocalizedString: String) {
            let filtered = Account.allCases.filter { $0.localizedString == byLocalizedString }
            if let value = filtered.first, filtered.count > 0 {
                self = value
            }else {
                return nil
            }
        }
    }
}


// Section 2
extension SettingViewController {
    enum Feature: String, CaseIterable {
        case cashed = "Remove Cashed Data"
        case language = "Language"
        
        var localizedString: String {
            return self.rawValue.localized()
        }
        
        init?(byLocalizedString: String) {
            let filtered = Feature.allCases.filter { $0.localizedString == byLocalizedString }
            if let value = filtered.first, filtered.count > 0 {
                self = value
            }else {
                return nil
            }
        }
        
    }
}

// Section 3
extension SettingViewController {
    enum Information: String, CaseIterable {
        case app_version = "App Version"
        case opensource_license = "Open-Source License"
        
        var localizedString: String {
            return self.rawValue.localized()
        }
        
        init?(byLocalizedString: String) {
            let filtered = Information.allCases.filter { $0.localizedString == byLocalizedString }
            if let value = filtered.first, filtered.count > 0 {
                self = value
            }else {
                return nil
            }
        }
    }
}

// Section 4
extension SettingViewController {
    enum Support: String, CaseIterable {
        case feedback = "FeedBack"
        
        var localizedString: String {
            return self.rawValue.localized()
        }
        
        init?(byLocalizedString: String) {
            let filtered = Support.allCases.filter { $0.localizedString == byLocalizedString }
            if let value = filtered.first, filtered.count > 0 {
                self = value
            }else {
                return nil
            }
        }
    }
}

// Section 5
extension SettingViewController {
    enum Logout: String, CaseIterable {
        case logout = "Logout"
        
        var localizedString: String {
            return self.rawValue.localized()
        }
        
        init?(byLocalizedString: String) {
            let filtered = Logout.allCases.filter { $0.localizedString == byLocalizedString }
            if let value = filtered.first, filtered.count > 0 {
                self = value
            }else {
                return nil
            }
        }
    }
}
