//
//  KeychainService.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import KeychainAccess

struct KeychainService {
    static var keychain: Keychain {
        return Keychain(
        server: "http://explog.ap-northeast-2.elasticbeanstalk.com",
        protocolType: .http)
    }
    private init() { }
}

extension KeychainService {
    enum Keys: String, CaseIterable {
        case token
        case pk
        case deviceToken
    }
}

extension KeychainService {
    static var token: String? {
        return keychain[Keys.token.rawValue]
    }
    
    static var pk: String? {
        return keychain[Keys.pk.rawValue]
    }
    
    static var deviceToken: String? {
        return keychain[Keys.deviceToken.rawValue]
    }
}

extension KeychainService {
    static func configure(material: String, key: KeychainService.Keys) {
        keychain[key.rawValue] = material
    }
    static func allClear() {
        do {
            for key in Keys.allCases {
                try keychain.remove(key.rawValue)
            }
        }catch {
            print("fail removing keychain items..")
        }
    }
}




