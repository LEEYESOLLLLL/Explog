//
//  Login.swift
//  Explog
//
//  Created by minjuniMac on 21/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import Moya
import SwiftyBeaver

enum Auth {
    case login(email: String, password: String)
    case signUp(username: String, email: String, password: String)
}

extension Auth: TargetType {
    var path: String {
        switch self {
        case .login(_, _): return "/member/login/"
        case .signUp(_, _, _): return "/member/signup/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login(_, _): return .post
        case .signUp(_, _, _): return .post
        }
        
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        // Serve API is some weird because even through statusCode is to be 400 and 200, the network response is in existence
        case .login(let email, let password):
            guard let multipartFormEmail = email.data(using: .utf8),
                let multipartFormPassword = password.data(using: .utf8) else {
                    SwiftyBeaver.info("Server error.. in login")
                    return .requestPlain
            }
            
            var multipartDataDic = Dictionary<String, Data>()
            if let deviceToken = KeychainService.deviceToken?.data(using: .utf8) {
                multipartDataDic = ["email": multipartFormEmail,
                                    "password": multipartFormPassword,
                                    "device-token": deviceToken]
            }else {
                multipartDataDic = ["email": multipartFormEmail,
                                    "password": multipartFormPassword]
            }
            return .uploadMultipart(multipartDataDic.convertedMutiPartFormData())
            
        case .signUp(let username, let email, let password):
            guard let multipartFormUsername = username.data(using: .utf8),
            let multipartFormEmail = email.data(using: .utf8),
                let multipartFormPassword = password.data(using: .utf8) else {
                    SwiftyBeaver.info("Server error.. in Sign up")
                    return .requestPlain
            }
            
            var multipartDataDic = Dictionary<String, Data>()
            
            if let deviceToken = KeychainService.deviceToken?.data(using: .utf8) {
                multipartDataDic = ["username": multipartFormUsername,
                                    "email": multipartFormEmail,
                                    "password": multipartFormPassword,
                                    "device-token": deviceToken]
            }else {
                multipartDataDic = ["username": multipartFormUsername,
                                    "email": multipartFormEmail,
                                    "password": multipartFormPassword]
            }
            return .uploadMultipart(multipartDataDic.convertedMutiPartFormData())
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

extension Dictionary where Key == String, Value == Data {
    func convertedMutiPartFormData() -> [MultipartFormData] {
        return self.compactMap { (key: String, value: Data) -> MultipartFormData in
            return MultipartFormData(provider: .data(value), name: key)
        }
    }
}
