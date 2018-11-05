//
//  SearchState.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension SearchViewController {
    enum State {
        case loading
        case ready(FeedModel)
    }
}
