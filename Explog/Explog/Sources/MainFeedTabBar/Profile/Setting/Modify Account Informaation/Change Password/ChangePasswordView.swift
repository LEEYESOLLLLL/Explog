//
//  ChangeView.swift
//  Explog
//
//  Created by MinjunJu on 02/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

final class ChangePasswordView: BaseView<ChangePasswordViewController> {
    
    lazy var backButton = UIBarButtonItem(
        image: #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: vc,
        action: #selector(vc.backButtonAction(_:))).then {
            $0.tintColor = .black
    }
    
    lazy var doneButton = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: vc,
        action: #selector(vc.doneButtonAction(_:))).then {
            $0.tintColor = .black
            $0.isEnabled = false
    }
    
    var oldPasswordTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "Old password"
        $0.title = "Old password"
        $0.isSecureTextEntry = true
    }
    
    var changePasswordTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "New password"
        $0.title = "New password"
        $0.isSecureTextEntry = true
    }
    
    var confirmPasswordTextField = SkyFloatingLabelTextField().then {
        $0.placeholder = "Confirm new password"
        $0.title = "Confirm new password"
        $0.isSecureTextEntry = true
    }
    
    var passwordTextfieldStakView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = UI.margin/2
    }
    
    struct UI {
        static var margin: CGFloat = 8
        static var stackViewMargin: CGFloat = UI.margin * 2
        static var stackViewHeight = UIScreen.mainHeight / 5
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubview(passwordTextfieldStakView)
        passwordTextfieldStakView.addArrangedSubviews([oldPasswordTextField, changePasswordTextField, confirmPasswordTextField])
        
        passwordTextfieldStakView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor, constant: UI.stackViewMargin)
            .leadingAnchor(to: layoutMarginsGuide.leadingAnchor, constant: UI.stackViewMargin)
            .trailingAnchor(to: layoutMarginsGuide.trailingAnchor, constant: -UI.stackViewMargin)
            .heightAnchor(constant: UI.stackViewHeight)
            .activateAnchors()
    }
    
    override func setupBinding() {
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.rightBarButtonItem = doneButton
        vc.navigationItem.title = "Change Password"
        
        oldPasswordTextField.addTarget(vc, action: #selector(vc.textFieldDidChange(_:)), for: .editingChanged)
        changePasswordTextField.addTarget(vc, action: #selector(vc.textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(vc, action: #selector(vc.textFieldDidChange(_:)), for: .editingChanged)        
    }
    
    func isActiveDoneButton(_ value: Bool) {
        doneButton.isEnabled = value
    }
    
}
