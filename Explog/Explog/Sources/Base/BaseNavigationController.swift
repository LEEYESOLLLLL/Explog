//
//  BaseNavigationController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

/**
 BaseNavigiationController is used as foundation of UINavigationController
 
 - warning: This class is not used yet
 */
public class BaseNavigiationController: UINavigationController, ViewControllerType {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self) have deinited")
    }
}

