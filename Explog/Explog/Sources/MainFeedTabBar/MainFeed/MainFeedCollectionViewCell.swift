//
//  MainFeedCollectionViewCell.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SnapKit

final class MainFeedCollectionViewCell: UICollectionViewCell {
    
    var lable: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    var tableView: UITableView = {
        var _tv = UITableView()
        _tv.rowHeight = UITableViewAutomaticDimension
        // 나중에 수정해주어야함
        _tv.estimatedRowHeight = 150 
        return _tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(cell: InsideTableViewCell.self)
        contentView.addSubviews([tableView])

        tableView
            .topAnchor(to: contentView.topAnchor, constant: 0)
            .bottomAnchor(to: contentView.bottomAnchor, constant: 0)
            .leadingAnchor(to: contentView.leadingAnchor, constant: 0)
            .trailingAnchor(to: contentView.trailingAnchor, constant: 0)
            .activateAnchors()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellDelegation<T: UITableViewDelegate & UITableViewDataSource>(owner: T) {
        tableView.delegate = owner
        tableView.dataSource = owner

    }
}


