//
//  LikeModel.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
// MARK: Like API Model
struct LikeModel: Codable {
    var liked: [Int]?
    var numLiked: Int?
    
    enum CodingKeys: String,CodingKey {
        case liked
        case numLiked = "num_liked"
    }
}

