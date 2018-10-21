//
//  Login.swift
//  Explog
//
//  Created by minjuniMac on 21/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import Moya

enum Login {
    
    case login(email: String, password: String, deviceToke: String?)
    
}


extension Login: TargetType {
    var path: String {
        return "/member/login/"
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        // Serve API is some weird because even through statusCode is to be 400 and 200, the network response is in existence
        case .login(let email, let password, let deviceToken):
            guard let multipartFormEmail = email.data(using: .utf8),
                let multipartFormPassword = password.data(using: .utf8) else {
                    return .requestPlain; print("Server error..")
            }
            
            var multipartforms: [MultipartFormData]?
            if let deviceToken = KeychainService.deviceToken?.data(using: .utf8) {
                multipartforms = [
                    MultipartFormData(
                        provider: .data(multipartFormEmail),
                        name: "email"),
                    MultipartFormData(
                        provider: .data(multipartFormPassword),
                        name: "password"),
                    MultipartFormData(
                        provider: .data(deviceToken),
                        name: "device-token")
                ]
            }else {
                multipartforms = [
                    MultipartFormData(
                        provider: .data(multipartFormEmail),
                        name: "email"),
                    MultipartFormData(
                        provider: .data(multipartFormPassword),
                        name: "password")
                ]
            }
            return .uploadMultipart(multipartforms!)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"
        ]
    }
}
