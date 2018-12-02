//
//  ChangeLanguageView.swift
//  Explog
//
//  Created by Minjun Ju on 26/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Localize_Swift
import M13Checkbox


final class ChangeLanguageView: BaseView<ChangeLanguageViewController> {
    var languageTableView = UITableView().then {
        $0.backgroundColor = . white
        $0.register(cell: ChangeLanguageCell.self)
        $0.register(headerFooter: SettingHeaderView.self)
    }
    
    lazy var backButton = UIBarButtonItem(
        image: #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: vc,
        action: #selector(vc.backButtonAction(_:))).then {
            $0.tintColor = .black
    }
    
    lazy var doneButton = UIBarButtonItem(
        title: "done".localized(),
        style: .done,
        target: vc,
        action: #selector(vc.doneButtonAction(_:))).then {
            $0.tintColor = .black
    }
    
    override func setupUI() {
        addSubviews([languageTableView])
        languageTableView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        languageTableView.delegate = vc
        languageTableView.dataSource = vc
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.rightBarButtonItem = doneButton
        vc.navigationItem.title = "Language".localized()
    }
}
