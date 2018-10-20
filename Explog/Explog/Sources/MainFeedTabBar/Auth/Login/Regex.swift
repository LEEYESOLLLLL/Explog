//
//  Regex.swift
//  Explog
//
//  Created by minjuniMac on 20/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

enum TextFieldType: String {
    case email = "Email"
    case password = "Password"
}

struct Validate {
    /**
     1. a 0 of index for validating email
     2. a 1 of index for validating password
        - All characters from 8 to 20 can be used as the passwrod
     */
    private var pattern: [String] = [
        "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
        "^.{8,20}"]
    private var regexs: [NSRegularExpression]!
    static var main = Validate()
    
    private init() {
        regexs = pattern.map {
            do {
                let regex = try NSRegularExpression(pattern: $0, options: .caseInsensitive)
                return regex
            }catch {
                fatalError("invalidate a Regular Expression Pattern")
            }
        }
    }
    func target(text: String, textFieldType: TextFieldType) -> Bool {
        switch textFieldType {
        case .email:
            return _validate(text: text, regex: regexs.first!)
        case .password:
            return _validate(text: text, regex: regexs.last!)
        }
        return false
    }
    
    private func _validate(text: String, regex: NSRegularExpression) -> Bool {
        let range = NSRange(text.startIndex..., in: text)
        let matchRange = regex.rangeOfFirstMatch(
            in: text,
            options: NSRegularExpression.MatchingOptions.reportProgress,
            range: range)
        return matchRange.location != NSNotFound
    }

    
    
}
