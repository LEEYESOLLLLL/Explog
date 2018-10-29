//
//  PostDetailModel.swift
//  Explog
//
//  Created by minjuniMac on 28/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

struct PostDetailModel: Codable {
    var postContents: [PostdetailContents]?
    
    enum CodingKeys: String, CodingKey {
        case postContents = "post_content"
    }
}

extension PostDetailModel {
    struct PostdetailContents: Codable {
        var post: Int
        var order: Int
        var contentType: String
        var contents: PostContentsType
        
        enum CodingKeys: String, CodingKey {
            case post
            case order
            case contentType = "content_type"
            case contents = "content"
        }
    }
}

extension PostDetailModel {
    struct PostContentsType:Codable {
        var pk: Int
        var content: String?
        var photo: String?
        var createdAt: String?
        var type: String?
        var postContentPk: Int
        
        enum CodingKeys: String, CodingKey {
            case pk
            case content
            case photo
            case createdAt = "created_at"
            case type
            case postContentPk = "post_content"
        }
    }    
}

extension PostDetailModel {
    static func + (left: PostDetailModel, right: PostDetailModel) -> PostDetailModel {
        guard let leftContents = left.postContents,
            let rightContents = right.postContents else {
                fatalError()
        }
        return PostDetailModel(postContents: leftContents + rightContents)
    }
}

