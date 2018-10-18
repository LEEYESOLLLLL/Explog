//
//  LikeViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class LikeViewController: BaseViewController {
    static func create() -> Self {
        let `self` = self.init()
        self.title = "Like"
        self.tabBarItem.image = #imageLiteral(resourceName: "LikeImageInTab")
        return self
    }
}

