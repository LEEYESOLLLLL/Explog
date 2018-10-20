//
//  AuthView.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class AuthView: BaseView<AuthViewController> {
    
    var dismissButton = UIButton().then {
        $0.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        $0.setTitle("X", for: .normal)
        $0.setTitleColor(.appStyle, for: .normal)
    }
    override func setupUI() {
        backgroundColor = .white
        addSubviews([dismissButton])
    }
    
    override func setupBinding() {
        dismissButton.addTarget(vc, action: #selector(vc.dismissButtonAction(_:)), for: .touchUpInside)
    }
}
