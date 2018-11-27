//
//  MainFeedTitles.swift
//  Explog
//
//  Created by Minjun Ju on 27/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import Localize_Swift

extension MainFeedTabBarViewController {
    enum Titles: String, CaseIterable {        
        case Feed
        case Search
        case Post
        case Noti
        case Profile
        
        init?(localizedString: String) {
            let filtered = Titles.allCases.filter { $0.rawValue.localized() == localizedString }
            if let value = filtered.first, filtered.count > 0  {
                self = value
            }else {
                return nil
            }
        }
    }
}
