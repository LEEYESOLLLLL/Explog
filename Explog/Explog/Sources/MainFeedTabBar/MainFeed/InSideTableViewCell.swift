//
//  InSideTableViewCell.swift
//  Explog
//
//  Created by minjuniMac on 8/30/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class InsideTableViewCell: UITableViewCell {
    /**
     when TableView is in UITableView or UICollectionView, internalIndex represents parent`s Index(for example row), my section and row 
     */
    public var internalIndex: (parentIndex: Int, section: Int, row: Int)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
