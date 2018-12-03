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
public class BaseTabBarController: UITabBarController, ViewControllerType, UnuniqueNameType {
    
    init(viewControllers vcs: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        viewControllers = vcs
        restorationIdentifier = unUniqueIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        restorationIdentifier = unUniqueIdentifier
    }
        
    deinit {
        SwiftyBeaver.info("\(self) have deinited")
    }
}
