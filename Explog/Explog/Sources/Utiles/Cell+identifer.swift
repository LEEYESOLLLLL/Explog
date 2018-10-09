//
//  UICollectionViewCell+identifer.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

import Foundation

public protocol CellType {
    static var identifier: String { get }
}

extension CellType {
    static public var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: CellType { }
// TableView
public extension UITableView {
    func register<Cell>(cell: Cell.Type,
                        forCellReuseIdentifier reuseIdentifier: String = Cell.identifier) where Cell: UITableViewCell {
        register(cell, forCellReuseIdentifier: reuseIdentifier)
    }
}

public extension UITableView {
    func dequeue<Cell>(_ reuseableCell: Cell.Type) -> Cell? where Cell: UITableViewCell {
        return dequeueReusableCell(withIdentifier: reuseableCell.identifier) as? Cell
    }
    
    func dequeue<Cell>(_ reuseableCell: Cell.Type, indexPath: IndexPath) -> Cell? where Cell: UITableViewCell {
        return dequeueReusableCell(withIdentifier: reuseableCell.identifier, for: indexPath) as? Cell
    }
}

extension UICollectionReusableView: CellType { }

public enum SupplementaryType {
    case header
    case footer
    var identifier: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

// Collection View
public extension UICollectionView {
    /**
     Register a class for use in creating new collection view cells.
     */
    func register<Cell>(cell: Cell.Type,
                        forCellReuseIdentifier reuseIdentifier: String = Cell.identifier) where Cell: UICollectionViewCell {
        register(cell, forCellWithReuseIdentifier: reuseIdentifier)
    }
    /**
     Registers a class for use in creating supplementary views for the collection view.
     */
    func register<Cell>(cell: Cell.Type,
                        forSupplementaryViewOfKind reuseSupplementaryViewType: SupplementaryType,
                        forCellReuseIdentifier reuseIdentifier: String = Cell.identifier) where Cell: UICollectionReusableView {
        register(cell, forSupplementaryViewOfKind: reuseSupplementaryViewType.identifier, withReuseIdentifier: reuseIdentifier)
    }
    
}

public extension UICollectionView {
    /**
     Returns a reusable cell object located by its identifier
     */
    func dequeue<Cell>(_ reuseableCell: Cell.Type,
                       indexPath: IndexPath) -> Cell? where Cell: UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: reuseableCell.identifier, for: indexPath) as? Cell
    }
    
    /**
     Returns a reusable supplementary view located by its identifier and kind.
     */
    func dequeue<Cell>(_ reuseableSupplementaryView: Cell.Type,
                       _ ofKind: SupplementaryType,
                       _ withReuseIdentifier: String = Cell.identifier,
                       indexPath: IndexPath) -> Cell? where Cell: UICollectionReusableView {
        
        return dequeueReusableSupplementaryView(ofKind: ofKind.identifier, withReuseIdentifier: withReuseIdentifier, for: indexPath) as? Cell
    }
}
