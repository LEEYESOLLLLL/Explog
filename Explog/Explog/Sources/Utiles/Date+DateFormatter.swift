//
//  Date+DateFormatter.swift
//  Explog
//
//  Created by minjuniMac on 23/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

extension Date {
    func convertedString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        return dateformatter.string(from: self)
    }
}

extension String {
    func convertDate() -> Date? {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy"
        
        return dateformatter.date(from: self)
    }
}

