//
//  RoundView.swift
//  Explog
//
//  Created by minjuniMac on 06/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class RoundShadowView: UIView {
    let contentView = UIView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = UI.layerCornerRadius
    }
    
    struct UI {
        static var layerCornerRadius: CGFloat = 14
        static var shadowRadius: CGFloat = 8.0
        static var shadowOpacity: Float = 0.65
        static var shodowOffset = CGSize(width: 10.0, height: 10.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(contentView)
        
        contentView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
    
    func setupShadow() {
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = UI.shodowOffset
        
        layer.shadowOpacity = UI.shadowOpacity
        layer.shadowRadius = UI.shadowRadius
    }
}
