//
//  BaseViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SwiftyBeaver

/**
 fundamental ViewController Protocol
 */
public protocol ViewControllerType: class {
    
}

/**
 BaseViewController is used as foundation of UIViewControllers
 */
public class BaseViewController: UIViewController, ViewControllerType, UnuniqueNameType {
    required init() {
        super.init(nibName: nil, bundle: nil)
        restorationIdentifier = unUniqueIdentifier
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        restorationIdentifier = unUniqueIdentifier
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        restorationIdentifier = unUniqueIdentifier
    }
    
    deinit {
        SwiftyBeaver.info("\(self) have deinited")
    }
}
