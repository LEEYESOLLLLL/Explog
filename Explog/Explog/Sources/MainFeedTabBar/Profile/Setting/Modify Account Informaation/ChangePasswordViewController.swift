//
//  ChangeViewController.swift
//  Explog
//
//  Created by MinjunJu on 02/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Square

final class ChangePasswordViewController: BaseViewController  {
    static func create() -> ChangePasswordViewController {
        let `self` = self.init()
        return self
    }
    lazy var v = ChangePasswordView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
}

extension ChangePasswordViewController  {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        // popNavigation ViewControlelr after Requesting to modify Password
        
        
    }
}
