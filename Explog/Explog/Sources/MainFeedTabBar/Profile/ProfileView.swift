//
//  ProfileView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class ProfileView: BaseView<ProfileViewController> {
    lazy var profileTableView = UITableView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .white
        $0.separatorStyle = .none
        $0.register(cell: ProfileCell.self)
        $0.refreshControl = refreshControl
    }
    
    var profileHeader = UIView().then {
        $0.backgroundColor = .white
    }
    
    var nameLabel = UILabel().then {
        $0.setup(textColor: .black, fontStyle: .headline, textAlignment: .center, numberOfLines: 1)
        
    }
    
    var profileImage = UIImageView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = UI.profileImageSize.width / 2
        $0.contentMode = .scaleToFill
    }
    
    var emailLabel = UILabel().then {
        $0.setup(textColor: .black, fontStyle: .headline, textAlignment: .center, numberOfLines: 1)
    }
    
    
    // MARK: Bug - UIBarButtonItem
    /**
     ```
     lazy var settingBarButton = UIBarButtonItem(image: nil,
     style: .plain,
     target: vc,
     action: #selector(vc.settingBarButtonAction(_:))).then {
     $0.setBackgroundImage(Some images, for: .normal, style: .plain, barMetrics: .default)
     }
     ```
     * When UIBarButtonItem is to initialize With `UIBarButtonItem(image:style:target:action)` method,
     * in iPhoneX, XR and XS Real Devices(Not simulator) UIBarButtonItem's TintColor do not working
     * I think to be in the connection that `lazy keyword` and iPhone X series bug
     */    
    lazy var settingBarButton = UIBarButtonItem(
        image: #imageLiteral(resourceName: "three-24px-black").withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: vc,
        action: #selector(vc.settingBarButtonAction(_:)))
    
    
    lazy var refreshControl = UIRefreshControl().then {
        $0.addTarget(vc, action: #selector(vc.refreshControlAction(_:)), for: .valueChanged)
    }
    
    lazy var backButton = UIBarButtonItem(
        image: #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: vc,
        action: #selector(vc.backButtonAction(_:)))
    struct UI {
        static var coverImageHeight: CGFloat = UIScreen.mainHeight * 0.3
        static var margin: CGFloat = 8
        static var profileImageSize = CGSize(width: UIScreen.mainHeight * 0.12,
                                             height: UIScreen.mainHeight * 0.12)
        static var topLabelMargin = UIApplication.shared.statusBarFrame.height + 8
        static var statusBarHeight = UIApplication.shared.statusBarFrame.height
        static var tableViewCellHegiht = UIScreen.mainHeight / 4.0
    }
    
    override func setupUI() {
        addSubviews([profileTableView])
        profileHeader.addSubviews([nameLabel, profileImage, emailLabel])
        
        profileTableView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        if let tabBar = vc.tabBarController?.tabBar {
            profileTableView.contentInset.bottom = tabBar.frame.height
        }
        
        _ = profileTableView.then {
            $0.parallaxHeader.view = profileHeader
            $0.parallaxHeader.height = UI.coverImageHeight
            $0.parallaxHeader.minimumHeight = 0
            $0.parallaxHeader.mode = .topFill
        }
        
        nameLabel
            .topAnchor(to: profileHeader.topAnchor, constant: UI.topLabelMargin)
            .leadingAnchor(to: profileHeader.leadingAnchor)
            .trailingAnchor(to: profileHeader.trailingAnchor)
            .activateAnchors()
        
        profileImage
            .topAnchor(to: nameLabel.bottomAnchor, constant: UI.margin)
            .centerXAnchor(to: nameLabel.centerXAnchor)
            .dimensionAnchors(size: UI.profileImageSize)
            .activateAnchors()
        
        emailLabel
            .topAnchor(to: profileImage.bottomAnchor, constant: UI.margin)
            .leadingAnchor(to: nameLabel.leadingAnchor)
            .trailingAnchor(to: nameLabel.trailingAnchor)
            .bottomAnchor(lessThanOrEqualTo: profileHeader.bottomAnchor, constant: -UI.margin)
            .activateAnchors()
    }
    
    override func setupBinding() {
        profileTableView.delegate = vc
        profileTableView.dataSource = vc
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        vc.navigationItem.title = nil
        vc.navigationController?.transparentNaviBar(true, navigationBarHidden: false)
        vc.navigationItem.rightBarButtonItem = vc.editMode == .on ? settingBarButton : nil 
        vc.navigationItem.leftBarButtonItem = vc.editMode == .on ? nil : backButton
        profileTableView
            .parallaxHeader
            .parallaxHeaderDidScrollHandler = { [weak vc, weak self] parallax in
                guard let strongVC = vc,
                    let self = self else {
                        return
                }
                let progress = parallax.progress
                let statnd = UI.statusBarHeight / parallax.height
                switch statnd >= progress {
                case true: // white
                    strongVC.navigationController?.navigationBar.barStyle = .black
                    self.backButton.image = #imageLiteral(resourceName: "back-24px-white").withRenderingMode(.alwaysOriginal)
                    self.settingBarButton.image = #imageLiteral(resourceName: "three-24px-white").withRenderingMode(.alwaysOriginal)
                case false: // black
                    strongVC.navigationController?.navigationBar.barStyle = .default
                    self.backButton.image = #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal)
                    self.settingBarButton.image = #imageLiteral(resourceName: "three-24px-black").withRenderingMode(.alwaysOriginal)
                }
        }
    }
    
    func initializeProfile(_ model: UserModel) {
        nameLabel.text = model.username
        emailLabel.text = model.email
        guard let profilePath = model.imgProfile,
            let profileURL = URL(string: profilePath) else {
                return
        }
        profileImage.kf.setImage(
            with: profileURL,
            placeholder: nil,
            options: [.transition(ImageTransition.fade(1))],
            progressBlock: nil,
            completionHandler: nil)
    }
}
