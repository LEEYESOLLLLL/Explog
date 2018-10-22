//
//  LoginModel.swift
//  Explog
//
//  Created by minjuniMac on 21/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

// MARK: LoginDataModel Set
struct AuthModel: Codable {
    var pk: Int
    var username: String
    var email: String
    var imgProfile: String
    var token: String
    var apnsdeviceSet: [DeviceTokenDataModel]?
    
    enum CodingKeys: String, CodingKey {
        case pk
        case username
        case email
        case imgProfile = "img_profile"
        case token
        case apnsdeviceSet = "apnsdevice_set"
    }
}

extension AuthModel {
    struct DeviceTokenDataModel: Codable {
        var deviceToken: String?
        enum CodingKeys: String, CodingKey {
            case deviceToken = "registration_id"
        }
    }
}

// MARK: Error Message DataModel
extension AuthModel {
    struct ErrorMessageDataModel: Codable {
        var username: String?
        var email: String?
        var message: String?
    }
}

