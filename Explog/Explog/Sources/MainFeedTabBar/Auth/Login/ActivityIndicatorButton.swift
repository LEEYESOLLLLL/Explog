//
//  LoginButton.swift
//  Explog
//
//  Created by minjuniMac on 21/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ActivityIndicatorButton: UIButton {
    var activityIndicator = UIActivityIndicatorView(style: .white)
    init() {
        super.init(frame: CGRect.zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(activityIndicator)
        activityIndicator
            .leadingAnchor(to: titleLabel!.trailingAnchor, constant: 6)
            .centerYAnchor(to: centerYAnchor)
            .activateAnchors()
    }
    
    func startAnimating() {
        self.activityIndicator.startAnimating()
        isUserInteractionEnabled = false
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        isUserInteractionEnabled = true 
    }
    
    
}
