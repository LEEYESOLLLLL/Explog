//
//  likeView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class NotiView: BaseView<NotiViewController> {
    var likeTableView = UITableView().then {
        $0.register(cell: NotiCell.self)
        $0.backgroundColor = .white
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 88
    }
    override func setupUI() {
        backgroundColor = .white
        addSubview(likeTableView)
        
        likeTableView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        likeTableView.delegate = vc
        likeTableView.dataSource = vc
    }
}
