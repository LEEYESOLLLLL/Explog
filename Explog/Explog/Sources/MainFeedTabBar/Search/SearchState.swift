//
//  SearchState.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension SearchViewController {
    typealias Posts = [FeedModel.Post]
    enum State {
        case loading
        case populated(posts: FeedModel)
        case paging(posts: FeedModel, nextPage: String)
        case empty
        case error(error: Error?, message: String)
        
        var currentPosts: Posts {
            switch self {
            case .populated(let item):
                return item.posts
            case .paging(let item, _):
                return item.posts
            default :
                return []
            }
        }   
    }
}
