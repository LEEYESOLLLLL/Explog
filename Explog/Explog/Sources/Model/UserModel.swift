//
//  UserModel.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

struct UserModel: Codable {
    var pk: Int
    var username: String
    var email: String
    var imgProfile: String?
    
    var followingnumber: Int
    var followernumber: Int
    var followingUsers: [followingDataModel]
    var followers: [followerDataModel]
    
    var posts: [UserPost]
    
    enum CodingKeys: String, CodingKey {
        case pk
        case username
        case email
        case imgProfile = "img_profile"
        case followingnumber = "following_number"
        case followernumber = "follower_number"
        case followingUsers = "following_users"
        case followers
        case posts
        
    }
}

// to user in future
extension UserModel {
    struct followingDataModel: Codable {
        var pk: Int
        var email: String
        var imgProfile: String
        var username: String
        var token: String?
        
        enum CodingKeys: String, CodingKey {
            case pk
            case email
            case username
            case imgProfile = "img_profile"
            case token
        }
    }
}

// to user in future
extension UserModel {
    struct followerDataModel: Codable {
        var pk: Int
        var email: String
        var imgProfile: String
        var username: String
        var token: String?
        
        enum CodingKeys: String, CodingKey {
            case pk
            case email
            case username
            case imgProfile = "img_profile"
            case token
        }
    }
}

extension UserModel {
    struct UserPost: Codable {
        var pk: Int
        var author: Int // It is not like FeedModel 's Post
        var title: String
        var startDate: String
        var endDate: String
        var continent: String
        var img: String?
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

extension UserModel {
    func author() -> FeedModel.Author {
        return FeedModel.Author(
            pk: self.pk,
            username: self.username,
            email: self.email,
            imgProfile: self.imgProfile!,
            token: "this tokne is not used")
    }
}


extension UserModel.UserPost {
    func converted(author: FeedModel.Author) -> FeedModel.Post {
        return FeedModel.Post(
            pk: self.pk,
            author: author,
            title: self.title,
            startDate: self.startDate,
            endDate: self.endDate,
            img: self.img,
            continent: self.continent,
            liked: self.liked,
            numLiked: self.numLiked)
    }
    
}
