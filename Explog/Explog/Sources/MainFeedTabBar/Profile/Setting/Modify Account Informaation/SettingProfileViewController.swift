//
//  SettingProfileViewController.swift
//  Explog
//
//  Created by minjuniMac on 01/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class SettingProfileViewController: BaseViewController {
    lazy var v = SettingProfileView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
    static func create() -> SettingProfileViewController {
        let `self` = self.init()
        return self
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        
    }
}
