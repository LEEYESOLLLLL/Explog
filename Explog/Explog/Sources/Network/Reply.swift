//
//  Reply.swift
//  Explog
//
//  Created by minjuniMac on 04/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya

enum Reply {
    case list(postPK: Int)
    case create(postPK: Int, comments: String)
    case delete(postPK: Int)
}

extension Reply: TargetType {
    var path: String {
        switch self {
        case .list(let postPK):      return "/post/\(postPK)/reply/"
        case .create(let postPK, _): return "/post/\(postPK)/reply/create/"
        case .delete(let postPK):    return "/post/reply/\(postPK)/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:   return .get
        case .create: return .post
        case .delete: return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .list: return .requestPlain
        case .create(_, let comments):
            guard let comments = comments.data(using: .utf8) else {
                return .requestPlain
            }
            return .uploadMultipart([MultipartFormData(
                provider: .data(comments), name: "content")])
        case .delete: return .requestPlain 
        }
    }
    
    var headers: [String : String]? {
        guard let token = KeychainService.token else { return nil }
        return [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json"]
    }
    
    
}
