//
//  Search.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya

enum Search {
    case retrieve(word: String)
    case next(word: String, query: String)
    
}

extension Search: TargetType {
    var path: String {
        switch self {
        case .retrieve: return "/post/search/"
        case .next:     return "/post/search/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .retrieve: return .post
        case .next:     return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .retrieve(let word):
            guard let word = word.data(using: .utf8) else {
                return .requestPlain
            }
            
            return .uploadMultipart([MultipartFormData(provider: .data(word), name: "word")])
            
        case .next(let word, let query):
            guard let word = word.data(using: .utf8) else {
                return .requestPlain
            }
            
            var splitedQuery = query.split(separator: "=").compactMap { String($0) }
            return .uploadCompositeMultipart([MultipartFormData(provider: .data(word), name: "word")],
                                             urlParameters: [splitedQuery[0]: splitedQuery[1]])
        }
    }
    
    var headers: [String : String]? {
        guard let token = KeychainService.token else { return nil }
        return [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json"]
    }
}
