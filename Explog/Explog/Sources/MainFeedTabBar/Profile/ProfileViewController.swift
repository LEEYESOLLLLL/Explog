//
//  ProfileViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ProfileViewController: BaseViewController {
    static func create() -> Self {
        let `self` = self.init()
        self.title = "Profile"
        self.tabBarItem.image = #imageLiteral(resourceName: "profileImage")
        return self
    }
}
