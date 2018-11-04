//
//  SettingView.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class SettingView: BaseView<SettingViewController> {
    
    var tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorInset = UIEdgeInsets(top: 0, left: UI.margin, bottom: 0, right: -UI.margin)
        $0.register(cell: SettingCell.self)
        $0.register(headerFooter: SettingHeaderView.self)
    }
    
    lazy var backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal),
                                          style: .plain,
                                          target: vc,
                                          action: #selector(vc.backButtonAction(_:)))
    
    struct UI {
        static var sectionHeight = UIScreen.main.bounds.height * 0.08
        static var margin: CGFloat = 4
    }
    override func setupUI() {
        backgroundColor = .white
        addSubview(tableView)
        
        tableView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        tableView.delegate = vc
        tableView.dataSource = vc
        setupNavigationBar()
        
    }
    
    func setupNavigationBar() {
        vc.navigationController?.transparentNaviBar(false, navigationBarHidden: false)
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.title = "Setting"
    }
    
    
}
