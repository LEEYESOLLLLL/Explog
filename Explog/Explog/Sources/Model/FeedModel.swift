//
//  CategoryModel.swift
//  Explog
//
//  Created by minjuniMac on 17/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

struct FeedModel: Codable {
    var posts: [Post]
    var previous: String?
    var next: String?
    
    var hasNext: Bool {
        return next != nil
    }
}

extension FeedModel {
    struct Post: Codable {
        var pk: Int
        var author: FeedModel.Author
        var title: String?
        var startDate: String?
        var endDate: String?
        var img: String?
        var continent: String
        var liked: [Int]
        var numLiked: Int
        
        enum CodingKeys: String, CodingKey {
            case pk
            case author
            case title
            case startDate = "start_date"
            case endDate = "end_date"
            case img
            case continent
            case liked
            case numLiked = "num_liked"
        }
        mutating func modifiedLike(model: LikeModel) {
            guard let liked = model.liked,
                let numLiked = model.numLiked else {
                    return
            }
            self.liked = liked
            self.numLiked = numLiked
        }
        
//        func encode() -> Data? {
//            let copy = self
//            guard let encoded = try? JSONEncoder().encode(copy) else {
//                return nil
//            }
//            return encoded
//        }
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

