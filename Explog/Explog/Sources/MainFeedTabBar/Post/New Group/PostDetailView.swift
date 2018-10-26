//
//  PostDetailView.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import ParallaxHeader

final class PostDetailView: BaseView<PostDetailViewController> {
    // TableView, EditButton, Button inside EditButton.., Model..
    // NavigationItem..
    // LikeButton, ReplyButton, DismissButton
    
    var postTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(cell: PostDetailTableViewCell.self)
        
        $0.parallaxHeader.view = UIImageView(image: #imageLiteral(resourceName: "account-background"))
        $0.parallaxHeader.height = UIScreen.main.bounds.height
        $0.parallaxHeader.minimumHeight = 0
        $0.parallaxHeader.mode = .topFill
    }
    
    // For HeaderView for TableView's ParallaxHeader
    var coverInformationView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var dismissButton = UIBarButtonItem(
        barButtonSystemItem: .stop,
        target: vc,
        action: #selector(vc.dismissButtonAction(_:))).then {
            $0.tintColor = .white
    }
    
    
    
    override func setupUI() {
        addSubviews([postTableView])
        
        postTableView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        postTableView.delegate = vc
        postTableView.dataSource = vc
        setupNavigationBar()
        
        
        postTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { parallaxHeader in
            print(parallaxHeader.progress)
            if parallaxHeader.progress <= 0.0 { }
        }        
    }
    
    func setupNavigationBar() {
        vc.navigationItem.leftBarButtonItem = dismissButton
        vc.navigationController?.transparentNaviBar()
    }
    
    
}

