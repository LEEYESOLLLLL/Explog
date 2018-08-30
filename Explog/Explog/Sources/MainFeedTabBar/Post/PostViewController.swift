//
//  PostViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class PostViewController: BaseViewController {
    static func createWith() -> Self {
        let `self` = self.init()
        self.title = "Post"
        self.tabBarItem.image = #imageLiteral(resourceName: "create_post")
        return self
    }
}
