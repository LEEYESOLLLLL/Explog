//
//  SkyScennerTextField+Style.swift
//  Explog
//
//  Created by minjuniMac on 20/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

extension SkyFloatingLabelTextField {
    /**
     set Colors that are lineColor, textColor, tintColor, selectedTitleColor and selectedLineColor for default style
     */
    func set(defaultColorStyle color: UIColor) {
        lineColor = color
        textColor = color
        tintColor = color
        selectedTitleColor = UIColor.appStyle
        selectedLineColor = color
        errorColor = .red 
    }
    
}
