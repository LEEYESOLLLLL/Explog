//
//  Noti.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya

enum Noti {
    case reset
    case list
    case next(query: String)
}

extension Noti: TargetType {
    var path: String {
        switch self {
        case .reset: return "/push/reset-badge/"
        case .list: return "/push/list/"
        case .next: return "/push/list/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .reset: return .get
        case .list:  return .get
        case .next:  return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .reset: return .requestPlain
        case .list: return .requestPlain
        case .next(let query):
            var splitedQuery = query.split(separator: "=").compactMap { String($0) }
            return .requestParameters(
                parameters: [splitedQuery[0]: splitedQuery[1]],
                encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        guard let token = KeychainService.token else { return nil }
        return [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json"]
    }    
}
