//
//  UISize+multiply.swift
//  Explog
//
//  Created by minjuniMac on 23/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit


extension CGSize {
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(
            width: lhs.height * rhs,
            height: lhs.height * rhs)
    }
}
