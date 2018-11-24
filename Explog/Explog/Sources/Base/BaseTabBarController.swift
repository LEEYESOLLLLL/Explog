//
//  BaseTabBarController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SwiftyBeaver

/**
 BaseTabBarController is used as foundation of UITabBarController
 */
public class BaseTabBarController: UITabBarController, ViewControllerType {
    
    init(viewControllers vcs: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = vcs
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        SwiftyBeaver.info("\(self) have deinited")
    }
}
