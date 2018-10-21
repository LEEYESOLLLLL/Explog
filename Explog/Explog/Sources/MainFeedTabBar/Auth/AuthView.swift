//
//  AuthView.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class AuthView: BaseView<AuthViewController> {
    var backgroundImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "account-background")
    }
    
    var dismissButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        $0.layer.shouldRasterize = true // for iPhone SE
    }
    
    var darkBlurView = UIVisualEffectView().then {
        $0.effect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .dark))
        $0.layer.opacity = 0.3
        $0.backgroundColor = UIColor.darkText
    }
    
    var logoLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = .white
        $0.text = "EXPLOG"
        $0.font = UIFont(name: .defaultFontName, size: 50)?.bold()
    }
    
    var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 30
        $0.distribution = .fillEqually
        $0.alignment = .fill
        
    }
    var emailLoginButton = UIButton().then {
        $0.setTitle("Login in with Email", for: [.normal, .highlighted])
        $0.setTitleColor(.white, highlightedStateColor: .gray)
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = .appStyle
        $0.setImage(#imageLiteral(resourceName: "new-email-outline"), for: .normal)
        $0.imageView?
            .centerYAnchor(to: $0.centerYAnchor)
            .leadingAnchor(to: $0.layoutMarginsGuide.leadingAnchor)
            .activateAnchors()
        $0.imageView?.layer.shouldRasterize = true
    }
    
    var signUpButton = UIButton().then {
        $0.setTitle("Sign Up", for: [.normal, .highlighted])
        $0.setTitleColor(.white, highlightedStateColor: .gray)
        $0.titleLabel?.textAlignment = .center
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    struct UI {
        static var dismissButtonTopMargin: CGFloat = 6
        static var logoLabelTopMargin: CGFloat = UIScreen.main.bounds.height/5
        static var stackViewBottomMargin: CGFloat = UIScreen.main.bounds.height/6
        static var stackViewleadingAndtrailingMargin: CGFloat = 6
    }
    override func setupUI() {
        backgroundColor = .clear
        addSubviews([backgroundImage, darkBlurView, dismissButton, logoLabel, stackView])
        stackView.addArrangedSubviews([emailLoginButton, signUpButton])
        
        backgroundImage
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        darkBlurView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        dismissButton
            .topAnchor(to: layoutMarginsGuide.topAnchor, constant: UI.dismissButtonTopMargin)
            .trailingAnchor(to: layoutMarginsGuide.trailingAnchor, constant: -UI.dismissButtonTopMargin)
            .activateAnchors()
        
        logoLabel
            .centerXAnchor(to: centerXAnchor)
            .topAnchor(to: topAnchor, constant: UI.logoLabelTopMargin)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        stackView
            .bottomAnchor(greaterThanOrEqualTo: bottomAnchor, constant: -UI.stackViewBottomMargin)
            .heightAnchor(constant: bounds.height/5)
            .leadingAnchor(to: layoutMarginsGuide.leadingAnchor , constant: UI.stackViewleadingAndtrailingMargin)
            .trailingAnchor(to: layoutMarginsGuide.trailingAnchor, constant: -UI.stackViewleadingAndtrailingMargin)
            .activateAnchors()
    }
    
    override func setupBinding() {
        dismissButton.addTarget(vc, action: #selector(vc.dismissButtonAction(_:)), for: .touchUpInside)
        emailLoginButton.addTarget(vc, action: #selector(vc.emailButtonAction(_:)), for: .touchUpInside)
        signUpButton.addTarget(vc, action: #selector(vc.signUpButtonAction(_:)), for: .touchUpInside)
    }
}
