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
    
    lazy var postTableView = UITableView().then {
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .white
        $0.register(cell: PostDetailTableViewCell.self)
    }
    
    var darkBlurView = UIVisualEffectView().then {
        $0.effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
        $0.layer.opacity = 0.3
        $0.backgroundColor = UIColor.darkText
    }
    
    lazy var dismissButton = UIBarButtonItem(
        barButtonSystemItem: .stop,
        target: vc,
        action: #selector(vc.dismissButtonAction(_:))).then {
            $0.tintColor = .white
    }
    
    lazy var likeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "like-24px"),
                                          style: .plain,
                                          target: vc,
                                          action: #selector(vc.likeButtonAction(_:))).then {
                                            $0.tintColor = .white
    }
    lazy var replyButton = UIBarButtonItem(image: #imageLiteral(resourceName: "reply"),
                                           style: .plain,
                                           target: vc,
                                           action: #selector(vc.replyButtonAction(_:))).then {
                                            $0.tintColor = .white
    }
    
    lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .compose,
                                          target: vc,
                                          action: #selector(vc.doneButtonAction(_:))).then {
                                            $0.tintColor = .white
    }
    
    // For HeaderView for TableView's ParallaxHeader
    var coverInformationView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var coverImage = UIImageView().then {
        $0.isUserInteractionEnabled = true
        $0.contentMode = .scaleToFill
        $0.layer.shouldRasterize = true
    }
    // CoverImage
    // 타이틀, Date, , continent,
    // author Button, Authortitle
    
    var titleLabel = UILabel().then {
        $0.setup(textColor: .white, fontStyle: .headline, textAlignment: .center, numberOfLines: 0)
        $0.font = UIFont(name: .defaultFontName, size: UI.titleHeaderFontSize)?.bold()
    }
    
    var dateLabel = UILabel().then {
        $0.setup(textColor: .white, fontStyle: .headline, textAlignment: .center, numberOfLines: 1)
    }
    
    var continentLabel = UILabel().then {
        $0.setup(textColor: .white, fontStyle: .headline, textAlignment: .center, numberOfLines: 1)
    }
    
    var dateAndContinentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .fill
    }
    
    var authorButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "continent1"), for: .normal)
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = UI.authorButtonDimension/2
        $0.clipsToBounds = true
    }
    
    var authorNickNameLabel = UILabel().then {
        $0.setup(textColor: .white, fontStyle: .headline, textAlignment: .center, numberOfLines: 1)
        $0.text = "Minjun"
    }
    
    var highlightTextButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "quotes"), for: .normal)
    }
    
    var normalTextButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "text"), for: .normal)
    }
    
    var photoButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "photo-camera"), for: .normal)
    }
    
    lazy var toggleView = ToggleView(elements: [(title: "Point",button: highlightTextButton),
                                                (title: "Note", button: normalTextButton),
                                                (title: "Photo", button: photoButton)],
                                     squreSide: UI.toggleViewSqureSide,
                                     color: .appStyle)
    
    /**
     this property is for flexible animation of toggleView
     */
    lazy var toggleViewWidth = NSLayoutConstraint(
        item: toggleView,
        attribute: NSLayoutConstraint.Attribute.width,
        relatedBy: NSLayoutConstraint.Relation.equal,
        toItem: self,
        attribute: NSLayoutConstraint.Attribute.width,
        multiplier: 0.0,
        constant: UI.toggleViewSqureSide)
    
    lazy var toggleViewTapGesture = UITapGestureRecognizer(target: vc, action: #selector(vc.toggleViewTapGestureAction(_:)))
    
    struct UI {
        static var margin: CGFloat = 8
        static var titleHeaderFontSize: CGFloat = 30
        static var dateAndContinetStackViewHeight: CGFloat = UIScreen.main.bounds.height/10
        static var authorButtonDimension: CGFloat = UIScreen.main.bounds.width * 0.175
        static var toggleViewSqureSide: CGFloat = UIScreen.main.bounds.width * 0.225
    }
    
    override func setupUI() {
        addSubviews([postTableView, coverInformationView, toggleView])
        coverInformationView.addSubviews([coverImage, darkBlurView, titleLabel, dateAndContinentStackView, authorButton, authorNickNameLabel])
        dateAndContinentStackView.addArrangedSubviews([dateLabel, continentLabel])
        
        postTableView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        _ = postTableView.then {
            $0.parallaxHeader.view = coverInformationView // ParallaxHeaderView is able to use its property after determining that parallaxHeader.view is assigned some View
            $0.parallaxHeader.height = UIScreen.main.bounds.height
            $0.parallaxHeader.minimumHeight = 0
            $0.parallaxHeader.mode = .topFill
        }
        
        coverImage
            .topAnchor(to: coverInformationView.topAnchor)
            .bottomAnchor(to: coverInformationView.bottomAnchor)
            .leadingAnchor(to: coverInformationView.leadingAnchor)
            .trailingAnchor(to: coverInformationView.trailingAnchor)
            .activateAnchors()
        
        darkBlurView
            .topAnchor(to: coverInformationView.topAnchor)
            .bottomAnchor(to: coverInformationView.bottomAnchor)
            .leadingAnchor(to: coverInformationView.leadingAnchor)
            .trailingAnchor(to: coverInformationView.trailingAnchor)
            .activateAnchors()
        
        titleLabel
            .centerYAnchor(to: coverInformationView.centerYAnchor, constant: -UIScreen.main.bounds.height*0.1)
            .leadingAnchor(to: coverInformationView.leadingAnchor)
            .trailingAnchor(to: coverInformationView.trailingAnchor)
            .activateAnchors()
        
        dateAndContinentStackView
            .topAnchor(to: titleLabel.bottomAnchor, constant: UI.margin)
            .leadingAnchor(to: titleLabel.leadingAnchor)
            .trailingAnchor(to: titleLabel.trailingAnchor)
            .heightAnchor(constant: UI.dateAndContinetStackViewHeight)
            .activateAnchors()
        
        authorButton
            .centerXAnchor(to: dateAndContinentStackView.centerXAnchor)
            .topAnchor(to: dateAndContinentStackView.bottomAnchor, constant: UI.margin)
            .dimensionAnchors(size: CGSize(width: UI.authorButtonDimension, height: UI.authorButtonDimension))
            .activateAnchors()
        
        authorNickNameLabel
            .topAnchor(to: authorButton.bottomAnchor, constant: UI.margin/2)
            .leadingAnchor(to: dateAndContinentStackView.leadingAnchor)
            .trailingAnchor(to: dateAndContinentStackView.trailingAnchor)
            .activateAnchors()
        
        toggleView
            .centerXAnchor(to: centerXAnchor)
            .bottomAnchor(to: bottomAnchor, constant: -UI.margin*2)
            .heightAnchor(constant: UI.toggleViewSqureSide)
            .activateAnchors()
        NSLayoutConstraint.activate([toggleViewWidth])
        
    }
    
    
    
    override func setupBinding() {
        setupCoverImage(vc.coverData)
        postTableView.delegate = vc
        postTableView.dataSource = vc
        setupNavigationBar()
        postTableView.parallaxHeader.parallaxHeaderDidScrollHandler = { [weak self] parallaxHeader in
            guard let strongSelf = self else { return }
            if parallaxHeader.progress <= 0.0 {
                strongSelf.vc.navigationController?.navigationBar.barTintColor = .appStyle
                strongSelf.vc.navigationController?.navigationBar.isTranslucent = false
            }else {
                strongSelf.vc.navigationController?.navigationBar.isTranslucent = true
            }
        }
        
        addGestureRecognizer(toggleViewTapGesture)
    }
    
    func setupNavigationBar() {
        vc.navigationItem.leftBarButtonItem = dismissButton
        vc.navigationItem.rightBarButtonItems = [doneButton, likeButton, replyButton]
        vc.navigationController?.transparentNaviBar(true)
        
        highlightTextButton.addTarget(vc, action: #selector(vc.highlightTextButtonAction(_:)), for: .touchUpInside)
        normalTextButton.addTarget(vc, action: #selector(vc.normalTextButtonAction(_:)), for: .touchUpInside)
        photoButton.addTarget(vc, action: #selector(vc.photoButtonAction(_:)), for: .touchUpInside)
    }
    
    func setupCoverImage(_ data: PostCoverModel) {
        guard let title = data.title,
            let startDate = data.startDate,
            let endDate = data.endDate,
            let continentMapValue = Int(data.continent),
            let continentType = ContinentPickerAlertViewController.ContinentType(rawValue: continentMapValue - 1),
            let img = data.img,
            let imgURL = URL(string: img),
            let authorURL = URL(string: data.author.imgProfile) else {
                return
        }
        
        coverImage.kf.setImage(with: imgURL,
                               placeholder: nil,
                               options: [.transition(.fade(1))],
                               progressBlock: nil,
                               completionHandler: nil)
        titleLabel.text = title
        dateLabel.text = "\(startDate) ~ \(endDate)"
        continentLabel.text = continentType.string
        authorButton.imageView?.kf.setImage(with: authorURL,
                                            placeholder: nil,
                                            options: [.transition(.fade(1))],
                                            progressBlock: nil,
                                            completionHandler: nil)
        authorNickNameLabel.text = data.author.username
    }
    
    func editmode(_ is: Bool) {
        if `is` {
            toggleView.isHidden = false
            vc.navigationItem.rightBarButtonItems = [doneButton ,likeButton, replyButton]
        }else {
            toggleView.isHidden = true
            vc.navigationItem.rightBarButtonItems = [likeButton, replyButton]
        }
    }
}

