//
//  ReplyModel.swift
//  Explog
//
//  Created by minjuniMac on 04/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

// MARK: Reply API Model
struct ReplyModel: Codable {
    var pk: Int
    var post: Int
    var content: String
    var author: FeedModel.Author?
    var createdAt: String
    
    enum CodingKeys: String, CodingKey {
        //case author
        case pk
        case post
        case content
        case author
        case createdAt = "created_at"
    }
}
