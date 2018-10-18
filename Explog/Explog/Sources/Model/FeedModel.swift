//
//  CategoryModel.swift
//  Explog
//
//  Created by minjuniMac on 17/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

struct FeedModel: Codable {
    var posts: [Posts]
    var previous: String?
    var next: String?
}

extension FeedModel {
    struct Posts: Codable {
        var pk: Int
        var author: Author
        var title: String
        var startDate: String
        var endDate: String
        var continent: String
        var img: String
        var liked: [Int]
        var numLiked: Int
        
        enum CodingKeys: String, CodingKey {
            case pk 
            case author
            case title
            case startDate = "start_date"
            case endDate = "end_date"
            case continent
            case img
            case liked
            case numLiked = "num_liked"
        }
    }
}

extension FeedModel {
    struct Author: Codable {
        var pk: Int
        var username: String
        var email: String
        var imgProfile: String
        var token: String
        
        enum CodingKeys: String, CodingKey {
            case pk
            case username
            case email
            case imgProfile = "img_profile"
            case token
        }
    }
}

extension FeedModel {
    static func + (left: FeedModel, right: FeedModel) -> FeedModel{
        return FeedModel(
            posts: left.posts + right.posts,
            previous: right.previous,
            next: right.next)
    }
}


