//
//  Post.swift
//  Explog
//
//  Created by minjuniMac on 24/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
import Moya
//title    포스트 하나의 제목    String    True
//start_date    여행 시작 시점    String
//end_date    여행이 끝나는 시    String
//continent    Post의 여행 대륙 정보를 표현    String
//img    포스트 표지사진 URL    String
enum Post {
    case post(title: String, startDate: String, endDate: String, continent: String, img: UIImage)
    case detail(postPK: Int)
    case text(postPK: Int, content: String, createdAt: String, type: String)
}

extension Post: TargetType {
    var path: String {
        switch self {
        case .post(_, _, _, _, _): return "/post/create/"
        case .detail(let postPK): return "/post/\(postPK)/"
        case .text(let postPK,_, _, _): return "/post/\(postPK)/text/"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .post(_, _, _, _, _):return .post
        case .detail(_): return .get
        case .text(_, _, _, _): return .post
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
                fileName: "\(UUID().uuidString).jpg",
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
        }
    }
    
    var headers: [String : String]? {
        guard let token = KeychainService.token else { return nil }
        return [
            "Authorization": "Token \(token)",
            "Content-Type": "application/json"]
    }
}
