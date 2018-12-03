//
//  BaseView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SwiftyBeaver


protocol ViewType {
    associatedtype ViewController: ViewControllerType
    //    weak var vc: ViewController! { get }
    //    https://github.com/apple/swift-evolution/blob/master/proposals/0186-remove-ownership-keyword-support-in-protocols.md
    init(controlBy viewController: ViewController)
}
/**
 Base View is used as foundation of UIView
 */
class BaseView<ViewController: ViewControllerType>: UIView, ViewType, UnuniqueNameType {
    weak var vc: ViewController!
    
    required init(controlBy viewController: ViewController) {
        vc = viewController
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        setupBinding()
        restorationIdentifier = unUniqueIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        restorationIdentifier = unUniqueIdentifier
    }
    
    /**
     Use Override when set Frame, Autolaout, Delegate and etc
     */
    func setupUI(){
        
    }
    
    /**
     Use Override when set soemthing else that except Frame, Autolaout, Delegate and etc
     */
    func setupBinding(){
        
    }
    
    deinit {
        SwiftyBeaver.info("BaseView: \(self) have deinited ")
    }
}
