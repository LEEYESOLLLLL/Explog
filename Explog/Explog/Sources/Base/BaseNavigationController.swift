//
//  BaseNavigationController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SwiftyBeaver

/**
 BaseNavigiationController is used as foundation of UINavigationController
 
 - warning: This class is not used yet
 */
public class BaseNavigiationController: UINavigationController, ViewControllerType, UnuniqueNameType {
    init(rootViewController: UIViewController, needRestorationClass: Bool = false) {
        super.init(rootViewController: rootViewController)
        commonInit()
        if needRestorationClass { restorationClass = type(of: self) }
        
    }
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    // MARK: Initialization Manager
    private func commonInit() {
        restorationIdentifier = unUniqueIdentifier
    }
    
    deinit {
        SwiftyBeaver.info("\(self) have deinited")
    }
}

extension BaseNavigiationController: UIViewControllerRestoration {
    public static func viewController(withRestorationIdentifierPath identifierComponents: [String], coder: NSCoder) -> UIViewController? {
        return self.init(coder: coder)
    }
}
