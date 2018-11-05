//
//  Post.swift
//  Explog
//
//  Created by minjuniMac on 24/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import Moya
extension Post {
    typealias ContentType = PostDetailViewController.ContentType
}

enum Post {
    case post(title: String, startDate: String, endDate: String, continent: String, img: UIImage)
    case detail(postPK: Int)
    case text(postPK: Int, content: String, createdAt: String, type: String)
    case photo(postPK: Int, photo: UIImage)
    case like(postPK: Int)
    case delete(postPK: Int)
    case deleteContents(contentType: ContentType, contentPK: Int)
}

extension Post: TargetType {
    var path: String {
        switch self {
        case .post(_, _, _, _, _):      return "/post/create/"
        case .detail(let postPK):       return "/post/\(postPK)/"
        case .text(let postPK,_, _, _): return "/post/\(postPK)/text/"
        case .photo(let postPK, _):     return "/post/\(postPK)/photo/"
        case .like(let postPK):         return "/post/\(postPK)/like/"
        case .delete(let postPK):       return "/post/\(postPK)/update/"
        case .deleteContents(let contentType, let contentPK):
            switch contentType {
            case .txt: return "/post/text/\(contentPK)/"
            case .img: return "/post/photo/\(contentPK)/"
            }
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .post(_, _, _, _, _): return .post
        case .detail(_):           return .get
        case .text(_, _, _, _):    return .post
        case .photo(_, _):         return .post
        case .like:                return .post
        case .delete:              return .delete
        case .deleteContents:      return .delete
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .post(let title, let startDate, let endDate, let continent, let img):
            guard let title = title.data(using: .utf8),
                let startDate = startDate.data(using: .utf8),
                let endDate = endDate.data(using: .utf8),
                let continent = continent.data(using: .utf8),
                let img = img.jpegData(compressionQuality: 0.3) else {
                    return .requestPlain
            }
            var multipartDataDic = ["title": title,
                                    "start_date": startDate,
                                    "end_date":endDate,
                                    "continent": continent].convertedMutiPartFormData()
            let multipartImg = MultipartFormData(
                provider: .data(img),
                name: "img",
                fileName: UUID().uuidString + ".jpg",
                mimeType: "image/jpg")
            multipartDataDic.append(multipartImg)
            return .uploadMultipart(multipartDataDic)
            
        case .detail(_):
            return .requestPlain
            
        case .text(_, let content, let createdAt, let type):
            guard let content = content.data(using: .utf8),
                let createdAt = createdAt.data(using: .utf8),
                let type = type.data(using: .utf8) else {
                    return .requestPlain
            }
            
            let multipartDataDic = ["content": content,
                                    "created_at": createdAt,
                                    "type":type].convertedMutiPartFormData()
            return .uploadMultipart(multipartDataDic)
        case .photo(_, let photo):
                guard let img = photo.jpegData(compressionQuality: 0.3) else {
                    return .requestPlain
                }
            return .uploadMultipart([MultipartFormData(
                provider: .data(img),
                name: "photo",
                fileName: UUID().uuidString + ".jpg",
                mimeType: "image/jpg")])
            
        case .like:           return .requestPlain
        case .delete:         return .requestPlain
        case .deleteContents: return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        guard let token = KeychainService.token else { return nil }
        return [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json"]
    }
}
