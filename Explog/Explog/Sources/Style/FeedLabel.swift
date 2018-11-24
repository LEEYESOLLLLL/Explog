//
//  FeedLabel.swift
//  Explog
//
//  Created by minjuniMac on 18/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UILabel {
    func setup(textColor color: UIColor,
               fontStyle style: UIFont.TextStyle,
               textAlignment alignment: NSTextAlignment,
               numberOfLines lines: Int) {
        
        textColor = color
        font = UIFont.preferredFont(forTextStyle: style)
        textAlignment = alignment
        numberOfLines = lines
        
    }
}
