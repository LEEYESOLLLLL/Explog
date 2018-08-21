//
//  UICollectionViewCell+identifer.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

protocol CellType {
    static var identifier: String { get }
}

extension UITableViewCell: CellType {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    func register<Cell>(cell: Cell.Type,
                        forCellReuseIdentifier reuseIdentifier: String = Cell.identifier) where Cell: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    func dequeue<Cell>(_ reuseableCell: Cell.Type) -> Cell? where Cell: UITableViewCell {
        return dequeueReusableCell(withIdentifier: reuseableCell.identifier) as? Cell
    }
}

extension UICollectionViewCell: CellType {
    static var identifier: String {
        return String(describing: self)
    }
}


extension UICollectionView {
    func register<Cell>(cell: Cell.Type,
                        forCellReuseIdentifier reuseIdentifier: String = Cell.identifier) where Cell: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func dequeue<Cell>(_ reuseableCell: Cell.Type, indexPath: IndexPath) -> Cell? where Cell: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: reuseableCell.identifier, for: indexPath) as? Cell
    }
}

