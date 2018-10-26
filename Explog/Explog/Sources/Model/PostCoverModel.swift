//
//  PostCoverModel.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation

struct PostCoverModel: Codable {
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
}
