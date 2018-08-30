//
//  File.swift
//  Explog
//
//  Created by minjuniMac on 8/30/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UICollectionView {
    convenience init(collectionViewLayout: UICollectionViewLayout) {
        self.init(
            frame: CGRect.zero,
            collectionViewLayout: collectionViewLayout)
    }
}
