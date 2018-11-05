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
}

extension Feed: TargetType {
    var path: String {
        switch self {
        case .category(let continent): return "/post/\(continent)/list"
        case .next(let continent, _):  return "/post/\(continent)/list"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .category:  return .get
        case .next:      return .get
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
        }
    }
    
    var headers: [String : String]? {
        
        switch self {
        case .category, .next:
            return ["Content-Type": "application/json"]
        }
    }
}
