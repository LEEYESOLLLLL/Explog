//
//  SignUpViewController.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

final class SignUpViewController: BaseViewController {
    lazy var v = SignUpView(controlBy: self)
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: SkyFloatingLabelTextField) {
        
    }
    
    @objc func signUpButtonAction(_ sender: ActivityIndicatorButton) {
        
    }
}

