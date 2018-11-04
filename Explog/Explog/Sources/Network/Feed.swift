//
//  Category.swift
//  Explog
//
//  Created by minjuniMac on 17/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import Moya

enum Feed {
    case category(continent: Int)
    case next(continent: Int, query: String)
    case like(postPK: Int)
}

extension Feed: TargetType {
    var path: String {
        switch self {
        case .category(let continent): return "/post/\(continent)/list"
        case .next(let continent, _):  return "/post/\(continent)/list"
        case .like(let postPK): return "/post/\(postPK)/like/"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .category:  return .get
        case .next:      return .get
        case .like:      return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .category: return .requestPlain
        case .next(_ , let query):
            var splitedQuery = query.split(separator: "=").compactMap { String($0) }
            
            return .requestParameters(
                parameters: [splitedQuery[0]: splitedQuery[1]],
                encoding: URLEncoding.default)
            
        case .like: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        
        switch self {
        case .category, .next:
            return ["Content-Type": "application/json"]
        case .like:
            guard let token = KeychainService.token else {
                return nil
            }
            return [
                "Authorization": "Token \(token)",
                "Content-Type": "application/json"]
        }
    }
}
