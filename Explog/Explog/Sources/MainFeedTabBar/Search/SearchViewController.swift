//
//  SearchViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class SearchViewController: BaseViewController {
    static func createWith() -> Self {
        let `self` = self.init()
        self.title = "Search"
        self.tabBarItem.image = #imageLiteral(resourceName: "search")
        return self
    }
}
