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
    case updateProfile(username: String, photo: UIImage)
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
        case .updateProfile(_, _): return "/member/userprofile/update/"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile(_): return .get
        case .updateProfile(_, _): return .patch
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .profile(_ ): return .requestPlain
        case .updateProfile(let username,let photo):
            guard let username = username.data(using: .utf8),
                let image = photo.jpegData(compressionQuality: 0.3) else {
                return .requestPlain
            }
            
            return .uploadMultipart([MultipartFormData(provider: .data(username),
                                                       name: "username"),
                                     MultipartFormData(provider: .data(image),
                                                       name: "img_profile",
                                                       fileName: UUID().uuidString + ".jpg",
                                                       mimeType: "image/jpg")
                ])
        }
    }
    
    var headers: [String : String]? {
        guard let token = KeychainService.token else { return nil }
        return [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json"]
    }
    
    
}

