//
//  EditModeState.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension PostDetailViewController {
    enum EditMode {
        case on
        case off
    }
    
    enum State {
        case loading
        case ready(detailModel: PostDetailModel)
    }
}

extension PostDetailViewController {
    enum ContentType: String  {
        case txt
        case img
    }
    
    typealias TextType = UploadTextViewController.TextType
}
extension PostDetailViewController {
    enum MoreButtonType: Int, CaseIterable {
        case cancel = 0
        case report
    }
}
