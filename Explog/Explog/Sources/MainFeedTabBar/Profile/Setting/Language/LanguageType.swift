//
//  LanguageType.swift
//  Explog
//
//  Created by Minjun Ju on 26/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension ChangeLanguageViewController {
    enum LanguageType: String, CaseIterable {
        case system = "System Language"
        case other = "Available Languages"
        
        /**
         return .self
         */
        static func section(_ n: Int) -> LanguageType? {
            guard allCases.count > n else {
                return nil
            }
            return n == 0 ? self.system : self.other
        }
    }
}
