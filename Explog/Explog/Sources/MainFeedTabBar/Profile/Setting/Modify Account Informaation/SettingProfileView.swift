//
//  SettingProfileView.swift
//  Explog
//
//  Created by minjuniMac on 01/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

// 보여줄 정보, ProfileImage && 같이 있는 Change Profile Photo -> 변경 가능
// Email
// UserName -> 변경 가능
// 비밀번호 변경창 -> 변경 가능
final class SettingProfileView: BaseView<SettingProfileViewController> {
    var scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    
    var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    
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
        addSubviews([scrollView])
        scrollView.addSubview(contentView)
        
        scrollView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        contentView
            .topAnchor(to: scrollView.topAnchor)
            .bottomAnchor(to: scrollView.bottomAnchor)
            .leadingAnchor(to: scrollView.leadingAnchor)
            .trailingAnchor(to: scrollView.trailingAnchor)
            .dimensionAnchors(size: scrollView.bounds.size)
            .activateAnchors()
        
        
        
    }
    
    override func setupBinding() {
        vc.navigationController?.transparentNaviBar(false, navigationBarHidden: false)
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.rightBarButtonItem = doneButton
        vc.navigationItem.title = "Profile Settings"
        
        
    }
}
