//
//  UIStackVIew+ArrangedSubview.swift
//  Explog
//
//  Created by minjuniMac on 20/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
