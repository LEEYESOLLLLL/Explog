//
//  FeedState.swift
//  Explog
//
//  Created by minjuniMac on 03/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension FeedTableViewController {
    enum State {
        case loading
        case ready(FeedModel)
        case error
    }
}
