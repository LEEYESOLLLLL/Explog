//
//  ReplyState.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension ReplyView {
    enum UploadState {
        case enabled
        case unable
    }
}

extension ReplyViewController {
    enum State {
        case loading
        case ready(item: [ReplyModel])
    }
}

