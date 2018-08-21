//
//  BaseView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

protocol ViewType {
    associatedtype ViewController: ViewControllerType
    weak var vc: ViewController! { get }
    init(controlBy viewController: ViewController)
}
/**
 Base View is used as foundation of UIView
 */
class BaseView<ViewController: ViewControllerType>: UIView, ViewType {
    weak var vc: ViewController!
    
    required init(controlBy viewController: ViewController) {
        vc = viewController
        super.init(frame: UIScreen.main.bounds)
        setupUI()
        setupBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    
}
