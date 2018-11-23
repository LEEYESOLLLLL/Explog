//
//  SearchState.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

/*
 SearchViewController에 필요한 상태는..
 loading, populated, pagenation, error, empty
 // 이거하기전에, 여러개의 컴퓨터에서 인증서 관리쉽게할수 있는것 찾아서 설치해놓자, 인증서 떄문에 귀찮아 지지 않게..
 */
extension SearchViewController {
    enum State {
        case loading
        case ready(FeedModel)
    }
}
