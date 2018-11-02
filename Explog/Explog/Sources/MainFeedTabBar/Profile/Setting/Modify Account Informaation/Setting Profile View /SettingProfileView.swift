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
    
    var profileImageButton = UIButton().then {
        $0.imageView?.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = UI.profileImageSize.width / 2
    }
    
    var changeProfileButton = UIButton().then {
        $0.setTitle("Change Profile Photo", for: [.normal, .highlighted])
        $0.setTitleColor(.appStyle, highlightedStateColor: .white)
        $0.titleLabel?.textAlignment = .center
    }
    
    var emailTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "Email"
        $0.title = "Email"
        $0.isUserInteractionEnabled = false
        
        $0.titleColor = .appStyle
        $0.lineColor = .black
    }
    
    var userNameTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "Username"
        $0.title = "Username"
        $0.selectedTitleColor = .appStyle
    }
    
    var textfieldStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = UI.margin
    }
    
    var activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    struct UI {
        static var profileImageSize = CGSize(width: UIScreen.main.bounds.width/3.8,
                                             height: UIScreen.main.bounds.width/3.8)
        static var margin: CGFloat = 8
        static var stackViewMargin: CGFloat = UI.margin * 2
        static var stackViewHeight = UIScreen.main.bounds.height / 8
    }
    
    
    override func setupUI() {
        backgroundColor = .white
        addSubviews([scrollView])
        scrollView.addSubview(contentView)
        contentView.addSubviews([profileImageButton, changeProfileButton, textfieldStackView, activityIndicator])
        textfieldStackView.addArrangedSubviews([emailTextField, userNameTextField])
        
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
            .heightAnchor(to: scrollView.heightAnchor)
            .widthAnchor(to: scrollView.widthAnchor)
            .activateAnchors()
        
        profileImageButton
            .topAnchor(to: contentView.layoutMarginsGuide.topAnchor)
            .centerXAnchor(to: contentView.centerXAnchor)
            .dimensionAnchors(size: UI.profileImageSize)
            .activateAnchors()

        changeProfileButton
            .topAnchor(to: profileImageButton.bottomAnchor, constant: UI.margin)
            .leadingAnchor(to: contentView.leadingAnchor)
            .trailingAnchor(to: contentView.trailingAnchor)
            .activateAnchors()
        
        textfieldStackView
            .topAnchor(to: changeProfileButton.bottomAnchor, constant: UI.margin)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor, constant: UI.stackViewMargin)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor, constant: -UI.stackViewMargin)
            .heightAnchor(constant: UI.stackViewHeight)
            .activateAnchors()
        
        activityIndicator
            .centerXAnchor(to: contentView.centerXAnchor)
            .centerYAnchor(to: contentView.centerYAnchor)
            .activateAnchors()
        
    }
    
    override func setupBinding() {
        vc.navigationController?.transparentNaviBar(false, navigationBarHidden: false)
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.rightBarButtonItem = doneButton
        vc.navigationItem.title = "Profile Settings"
        profileImageButton.addTarget(vc, action: #selector(vc.profileButtonAction(_:)), for: .touchUpInside)
        changeProfileButton.addTarget(vc, action: #selector(vc.profileButtonAction(_:)), for: .touchUpInside)
        userNameTextField.addTarget(vc, action: #selector(vc.didChangeTextField(_:)), for: .editingChanged)
        userNameTextField.delegate = vc
    }
    
    func configureUI(with model: UserModel) {
        guard let imgPath = model.imgProfile,
            let imgURL = URL(string: imgPath) else {
                return
        }
        profileImageButton.kf.setImage(with: imgURL,
                                       for: .normal,
                                       placeholder: nil,
                                       options: [.transition(.fade(0.5))],
                                       progressBlock: nil,
                                       completionHandler: nil)
        
        emailTextField.text = model.email
        userNameTextField.text = model.username
    }
    
    func start(_ initialization: Bool) {
        let defaultValue: Float = initialization ? 0.0 : 1.0
        initialization ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        changeProfileButton.layer.opacity = defaultValue
        emailTextField.layer.opacity = defaultValue
        userNameTextField.layer.opacity = defaultValue
    }
    
    func configure(image: UIImage) {
        profileImageButton.setImage(image, for: .normal)
    }
}
