//
//  PersistenceService.swift
//  Explog
//
//  Created by Minjun Ju on 13/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import KeychainAccess
import SwiftyBeaver

struct Persistence {
    static var service: Keychain {
        return Keychain(server: "kr.explog.persistence",
                        protocolType: .http)
    }
    private init() { }
}

extension Persistence {
    enum Keys: String, CaseIterable {
        case properPostingAgreement
    }
}

extension Persistence {
    private static var properPosting: String? {
        return service[Keys.properPostingAgreement.rawValue]
    }
    
    static var isConfirm: Bool {
        return service[Keys.properPostingAgreement.rawValue] != nil
    }
}

extension Persistence {
    static func setValue(_ agreement: Bool = true,
                         key: Persistence.Keys = .properPostingAgreement) {
        service[Keys.properPostingAgreement.rawValue] = agreement ? "Agreement" : nil
    }
}

extension Persistence {
    static func allClear() {
        for item in Keys.allCases {
            do {
                try service.remove(item.rawValue)
            }catch {
                SwiftyBeaver.info("not found key")
            }
        }
    }
}

