//
//  SettingHeaderView.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class SettingHeaderView: UITableViewHeaderFooterView {
    
    var sectionTitle = UILabel().then {
        $0.setup(textColor: .gray, fontStyle: .headline, textAlignment: .left, numberOfLines: 1)
    }
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct UI {
        static var margin: CGFloat = 8
    }
    
    func setupUI() {
        contentView.addSubviews([sectionTitle])
        sectionTitle
            .bottomAnchor(to: contentView.bottomAnchor, constant: -UI.margin/2)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor)
            .trailingAnchor(to: contentView.trailingAnchor)
            .activateAnchors()
        
    }
    
    func setupBinding() {
        
    }
}
