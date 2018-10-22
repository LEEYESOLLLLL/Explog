//
//  SignUpView.swift
//  Explog
//
//  Created by minjuniMac on 20/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

final class SignUpView: BaseView<SignUpViewController> {
    
    var containerScrollView = UIScrollView().then {
        $0.backgroundColor = .clear
    }
    
    var contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    var darkBlurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .dark)
        $0.layer.opacity = 1.0
    }
    
    var dismissButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        $0.layer.shouldRasterize = true // for iPhone SE
    }
    
    var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    var usernameTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "Username"
        $0.title = "Vaild Username"
        $0.set(defaultColorStyle: .white)
    }
    
    var emailTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "Email"
        $0.title = "Vaild Email"
        $0.set(defaultColorStyle: .white)
    }
    
    var passwordTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "Password"
        $0.title = "Vaild Password"
        $0.isSecureTextEntry = true
        $0.set(defaultColorStyle: .white)
        $0.rightViewMode = .always
    }
    
    var showSecurityTextButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(#imageLiteral(resourceName: "view"), for: .normal)
        $0.layer.shouldRasterize = true
    }
    
    var signUpButton = ActivityIndicatorButton().then {
        $0.setTitle("Sign up", for: [.normal, .highlighted])
        $0.setTitleColor(.gray, highlightedStateColor: .blue)
        $0.isUserInteractionEnabled = false
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 2
    }
    
    struct UI {
        static var dismissButtonMargin: CGFloat = 6
        static var stackViewleadingAndtrailingMargin: CGFloat = 6
        static var stackViewTopMargin: CGFloat = UIScreen.main.bounds.height/7
        static var stackViewHeight: CGFloat = UIScreen.main.bounds.height/4
        static var loginBuggonTopMargin: CGFloat = 20
    }
    
    override func setupUI() {
        backgroundColor = .clear
        addSubviews([containerScrollView])
        containerScrollView.addSubview(contentView)
        contentView.addSubviews([darkBlurView, dismissButton, stackView, signUpButton, showSecurityTextButton])
        stackView.addArrangedSubviews([usernameTextField, emailTextField, passwordTextField])
        
        containerScrollView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        contentView
            .topAnchor(to: containerScrollView.topAnchor)
            .bottomAnchor(to: containerScrollView.bottomAnchor)
            .leadingAnchor(to: containerScrollView.leadingAnchor)
            .trailingAnchor(to: containerScrollView.trailingAnchor)
            .dimensionAnchors(size: UIScreen.main.bounds.size)
            .activateAnchors()
        
        darkBlurView
            .topAnchor(to: contentView.topAnchor)
            .bottomAnchor(to: contentView.bottomAnchor)
            .leadingAnchor(to: contentView.leadingAnchor)
            .trailingAnchor(to: contentView.trailingAnchor)
            .activateAnchors()
        
        dismissButton
            .topAnchor(to: contentView.layoutMarginsGuide.topAnchor, constant: UI.dismissButtonMargin)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor, constant: -UI.dismissButtonMargin)
            .activateAnchors()
        
        stackView
            .topAnchor(to: contentView.layoutMarginsGuide.topAnchor, constant: UI.stackViewTopMargin)
            .heightAnchor(constant: UI.stackViewHeight)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor, constant: UI.stackViewleadingAndtrailingMargin)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor, constant: -UI.stackViewleadingAndtrailingMargin)
            .activateAnchors()
        
        showSecurityTextButton
            .centerYAnchor(to: passwordTextField.centerYAnchor)
            .trailingAnchor(to: passwordTextField.layoutMarginsGuide.trailingAnchor)
            .activateAnchors()
        
        signUpButton
            .topAnchor(to: stackView.bottomAnchor, constant: UI.loginBuggonTopMargin)
            .leadingAnchor(to: stackView.leadingAnchor)
            .trailingAnchor(to: stackView.trailingAnchor)
            .heightAnchor(to: passwordTextField.heightAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        dismissButton.addTarget(vc, action: #selector(vc.dismissButtonAction(_:)), for: .touchUpInside)
        usernameTextField.addTarget(vc, action: #selector(vc.textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(vc, action: #selector(vc.textFieldDidChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(vc, action: #selector(vc.textFieldDidChange(_:)), for: .editingChanged)
        showSecurityTextButton.addTarget(vc, action: #selector(vc.showSecurityTextButtonAction(_:)), for: .touchUpInside)
        signUpButton.addTarget(vc, action: #selector(vc.signUpButtonAction(_:)), for: .touchUpInside)
        
    }
    
    func showSecurityText() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    func verifyTextFieldState(_ skyTextField: SkyFloatingLabelTextField) {
        if skyTextField === usernameTextField {
            skyTextField.errorMessage = "Invaild Username"
        }else if skyTextField === emailTextField {
            skyTextField.errorMessage = "Invaild Email"
        }else if skyTextField === passwordTextField {
            skyTextField.errorMessage = "Invaild Password"
        }
        
        skyTextField.titleColor = .gray
    }
    
    func verifySignUpButtonState() {
        guard let userErrorMessage = usernameTextField.errorMessage,
            let emailErrorMessage = emailTextField.errorMessage,
            let passwordErrorMessage = passwordTextField.errorMessage,
            userErrorMessage.count == 0,
            emailErrorMessage.count == 0,
            passwordErrorMessage.count == 0 else {
                vaildSignUpButton(titleColor: .gray, userInteraction: false)
                return
        }
        vaildSignUpButton(titleColor: .white, userInteraction: true)
    }
    
    private func vaildSignUpButton(titleColor color: UIColor, userInteraction: Bool) {
        signUpButton.setTitleColor(color, for: .normal)
        signUpButton.layer.borderColor = color.cgColor
        signUpButton.isUserInteractionEnabled = userInteraction
    }
    
    
}
