//
//  ChangeView.swift
//  Explog
//
//  Created by MinjunJu on 02/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

final class ChangePasswordView: BaseView<ChangePasswordViewController> {
    
    lazy var backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-24pk"),
                                          style: .plain,
                                          target: vc,
                                          action: #selector(vc.backButtonAction(_:))).then {
                                            $0.tintColor = .black
    }
    lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                          target: vc,
                                          action: #selector(vc.doneButtonAction(_:))).then {
                                            $0.tintColor = .black
    }
    
    
    override func setupUI() {
        backgroundColor = .white 
        
    }
    
    override func setupBinding() {
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.rightBarButtonItem = doneButton
        vc.navigationItem.title = "Change Password"
    }
    
    
}
