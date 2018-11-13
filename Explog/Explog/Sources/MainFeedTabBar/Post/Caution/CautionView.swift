//
//  CautionView.swift
//  Explog
//
//  Created by Minjun Ju on 13/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class CautionView: BaseView<CautionViewController> {
    var darkBlurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .dark)
        $0.layer.opacity = 0.65
        $0.backgroundColor = .darkText
    }
    
    var dismissButton = UIButton().then {
        $0.backgroundColor = .clear 
        $0.setImage(#imageLiteral(resourceName: "cancel-1"), for: .normal)
    }
    
    var agreementTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.isEditable = false
        $0.textColor = .white
        $0.textAlignment = .natural
        $0.font = UIFont(name: .defaultFontName, size: 17)
        $0.text = CautionView.agreement_Text
        
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    var agreementButton = UIButton().then {
        $0.setTitle("Confirm", for: [.normal, .highlighted])
        $0.setTitleColor(.white, highlightedStateColor: .clear)
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 1
    }
    
    var agreementStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    struct UI {
        static var dismissButtonSize = UIScreen.mainSize * 0.024
        static var margin: CGFloat = 6
        static var stackViewSize = CGSize(width: UIScreen.mainWidth * 0.8,
                                          height: UIScreen.mainHeight * 0.4)
        static var confirmButtonHeight: CGFloat = 50
    }
    
    // Textfield, //확인 눌렀을때 콜백.
    override func setupUI() {
        backgroundColor = .clear
        addSubviews([darkBlurView, dismissButton, agreementStackView])
        agreementStackView.addArrangedSubviews([agreementTextView, agreementButton])
        
        darkBlurView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        dismissButton
            .topAnchor(to: layoutMarginsGuide.topAnchor, constant:UI.margin)
            .leadingAnchor(to: layoutMarginsGuide.leadingAnchor)
            .dimensionAnchors(size: UI.dismissButtonSize)
            .activateAnchors()
        
        agreementButton
            .heightAnchor(constant: UI.confirmButtonHeight)
            .activateAnchors()
        
        agreementStackView
            .centerXAnchor(to: centerXAnchor)
            .centerYAnchor(to: centerYAnchor)
            .dimensionAnchors(size: UI.stackViewSize)
            .activateAnchors()
    }
    
    override func setupBinding() {
        agreementTextView.delegate = vc
        dismissButton.addTarget(vc, action: #selector(vc.dismissButtonAction(_:)), for: .touchUpInside)
        agreementButton.addTarget(vc, action: #selector(vc.dismissButtonAction(_:)), for: .touchUpInside)
    }
}
