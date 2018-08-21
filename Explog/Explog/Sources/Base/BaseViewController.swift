//
//  BaseViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

/**
 fundamental ViewController Protocol
 */
public protocol ViewControllerType: class {
    
}

/**
 BaseViewController is used as foundation of UIViewControllers
 */
public class BaseViewController: UIViewController, ViewControllerType {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(self) have deinited")
    }
}



