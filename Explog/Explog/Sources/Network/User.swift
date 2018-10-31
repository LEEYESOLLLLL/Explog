//
//  User.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya

enum User {
    case profile(otherUserPK: Int?)
}

extension User: TargetType {
    var path: String {
        switch self {
        case .profile(let otherUserPK):
            if let otherUserPK = otherUserPK {
                return "/member/userprofile/\(otherUserPK)/"
            }else {
                return "/member/userprofile/"
            }
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile(_): return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .profile(_ ): return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        guard let token = KeychainService.token else { return nil }
        return [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json"]
    }
    
    
}

