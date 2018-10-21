//
//  UIButton+setTitle.swift
//  Explog
//
//  Created by minjuniMac on 21/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UIButton {
    func setTitle(_ title: String, for states: [UIControl.State]) {
        for state in states {
            setTitle(title, for: state)
        }
    }
    
    func setTitleColor(_ normalStateColor: UIColor, highlightedStateColor: UIColor) {
        setTitleColor(normalStateColor, for: .normal)
        setTitleColor(highlightedStateColor, for: .highlighted)
    }
    
}
