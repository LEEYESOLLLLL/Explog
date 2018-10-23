//
//  ProfileView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ProfileView: BaseView<ProfileViewController> {
    
    var logoutButton = UIButton().then {
        $0.setTitle("Log out", for: [.normal, .highlighted])
        $0.setTitleColor(.black, highlightedStateColor: .gray)
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubview(logoutButton)
        
        logoutButton
            .topAnchor(to: layoutMarginsGuide.topAnchor)
            .leadingAnchor(to: layoutMarginsGuide.leadingAnchor)
            .activateAnchors()
        
    }
    
    override func setupBinding() {
        logoutButton.addTarget(vc, action: #selector(vc.logoutButtonAction(_:)), for: .touchUpInside)
        
    }
}
