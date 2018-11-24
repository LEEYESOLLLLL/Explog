//
//  FeedState.swift
//  Explog
//
//  Created by minjuniMac on 03/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension FeedTableViewController {
    typealias Posts = [FeedModel.Post]
    enum State {
        case initial
        case loading
        case populated(feedModel: FeedModel)
        case paging(feedModel: FeedModel, nextPage: String)
        case errorWithRetry
        
        var currentFeedModel: Posts {
            switch self {
            case .populated(let feeeModel):
                return feeeModel.posts
            case .paging(let feedModel, _):
                return feedModel.posts
            default:
                return []
            }
        }
    }
}
