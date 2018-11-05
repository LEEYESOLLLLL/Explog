//
//  NotiModel.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import Foundation
// Noti List API Data Model
struct NotiListModel: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [NotiInfo]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}

extension NotiListModel {
    struct NotiInfo: Codable {
        var likedDate: String
        var author: User
        var posttitle: String
        
        enum CodingKeys: String, CodingKey {
            case likedDate = "liked_date"
            case author
            case posttitle = "post"
        }
    }
}

extension NotiListModel {
    struct User: Codable {
        var username: String
        var imgProfile: String
        
        enum CodingKeys: String, CodingKey {
            case username
            case imgProfile = "img_profile"
        }
    }
}

extension NotiListModel {
    static func + (left: NotiListModel, right: NotiListModel) -> NotiListModel? {
        guard let leftResults = left.results,
            let rightResults = right.results else {
            return nil
        }
        return NotiListModel(count: leftResults.count + rightResults.count,
                             next: right.next,
                             previous: right.previous,
                             results: leftResults + rightResults)
    }
    
}
