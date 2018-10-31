//
//  ProfilePostDetailView.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ProfilePostDetailView: PostDetailView  {
    typealias ViewController = ProfilePostDetailViewController
    
    override func setupNavigationBar() {
        vc.navigationItem.leftBarButtonItem = dismissButton
        switch vc.editMode {
        case .on: vc.navigationItem.rightBarButtonItems = [likeButton, replyButton]
        case .off: vc.navigationItem.rightBarButtonItems = [likeButton, replyButton]
        }
        vc.navigationController?.transparentNaviBar(true)
        highlightTextButton.addTarget(vc, action: #selector(vc.highlightTextButtonAction(_:)), for: .touchUpInside)
        normalTextButton.addTarget(vc, action: #selector(vc.normalTextButtonAction(_:)), for: .touchUpInside)
        photoButton.addTarget(vc, action: #selector(vc.photoButtonAction(_:)), for: .touchUpInside)
    }
}
