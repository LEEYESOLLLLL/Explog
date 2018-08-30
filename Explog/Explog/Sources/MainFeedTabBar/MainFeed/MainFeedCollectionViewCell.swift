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
            .topAnchor(to: contentView.safeAreaLayoutGuide.topAnchor, constant: 0)
            .bottomAnchor(to: contentView.bottomAnchor, constant: 0)
            .leadingAnchor(to: contentView.leadingAnchor, constant: 0)
            .trailingAnchor(to: contentView.trailingAnchor, constant: 0)
            .activateAnchors()
        setupCellBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellBinding() {
        tableView.delegate = self
        tableView.dataSource = self

    }
}

extension MainFeedCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) 
        let superViewCell = (superview as? UICollectionViewCell)
        
        
    }
    
}

extension MainFeedCollectionViewCell: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 20
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(InsideTableViewCell.self)!
        cell.internalIndex = (
            parentIndex: tableView.tag,
            section: indexPath.section,
            row: indexPath.row)
        cell.backgroundColor = .blue
        cell.textLabel?.text = "\(indexPath)"
        
        return cell
        
        
    }

    
}
