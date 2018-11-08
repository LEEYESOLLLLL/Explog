//
//  File.swift
//  Explog
//
//  Created by minjuniMac on 08/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

protocol Localizable {
    func localizedValue() -> String
}

enum PrivateAccessLevel: String, Localizable {
    case denied = "DENIED"
    case granted = "GRANTED"
    case restricted = "RESTRICTED"
    case undetermined = "UNDETERMINED"
    
    func localizedValue() -> String {
        return NSLocalizedString(self.rawValue, comment: "Access level label for \(self.rawValue)")
    }
}

/**
 A type describing an `PrivateAccessLevel` to the user's private data.
 */
protocol PrivateAccessLevelConvertible {
    var accessLevel: PrivateAccessLevel { get }
}


/**
 A struct containing the results of prompting the user for access to a subset of their private data.
 */
struct PrivateRequestAccessResult: Localizable {
    let accessLevel: PrivateAccessLevel
    let error: NSError?
    let errorMessageKey: String?
    
    init(_ accessLevel: PrivateAccessLevel, error: NSError? = nil, errorMessageKey: String? = nil) {
        self.accessLevel = accessLevel
        self.error = error
        self.errorMessageKey = errorMessageKey
    }
    
    func localizedValue() -> String {
        var message = accessLevel.localizedValue()
        
        if let errorMessageKey = errorMessageKey, let error = error {
            let localizedErrorFormatString = NSLocalizedString(errorMessageKey, comment: "")
            let errorDescription = String(format: localizedErrorFormatString, error.code, error.localizedDescription)
            message += " \(errorDescription)"
        }
        
        return message
    }
}

