//
//  AppInfo.swift
//  Explog
//
//  Created by Minjun Ju on 26/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya

enum AppVersion {
    case latest
}

extension AppVersion: TargetType {
    var baseURL: URL {
        return URL(string: "http://itunes.apple.com/lookup")!
    }
    var path: String {
        switch self {
        case .latest: return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .latest: return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .latest:
            return .requestParameters(parameters: ["bundleId":"kr.mjun.explog"],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

