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
}

extension KeychainService {
    static var token: String? {
        return self.keychain["token"]
    }
    
    static var pk: String? {
        return self.keychain["pk"]
    }
    
    static var deviceToken: String? {
        return self.keychain["deviceToken"]
    }
    
}

