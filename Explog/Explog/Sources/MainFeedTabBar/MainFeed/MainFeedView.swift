//
//  MainFeedView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SnapKit

final class MainFeedView: BaseView<MainFeedViewController> {
    
    struct UI {
        static let collectionViewFrame = UIScreen.main.bounds
    }
    
    let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let _cvFlowLayout = UICollectionViewFlowLayout()
        _cvFlowLayout.scrollDirection = .vertical
        _cvFlowLayout.minimumLineSpacing = 0
        _cvFlowLayout.minimumInteritemSpacing = 1
        _cvFlowLayout.itemSize = UILayoutGuide().layoutFrame.size
        return _cvFlowLayout
    }()
    
    let collectionView: UICollectionView = {
        let _cvFlowLayout = UICollectionViewFlowLayout()
        _cvFlowLayout.scrollDirection = .horizontal
        _cvFlowLayout.minimumLineSpacing = 1
        let cv = UICollectionView.init(collectionViewLayout: _cvFlowLayout)
        return cv
    }()
    
    
    
    
    
    override func setupUI() {
        collectionView.register(cell: MainFeedCollectionViewCell.self)
        addSubviews([collectionView])
        collectionView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor, constant: 0)
            .bottomAnchor(to: safeAreaLayoutGuide.bottomAnchor, constant: 0)
            .leadingAnchor(to: leadingAnchor, constant: 0)
            .trailingAnchor(to: trailingAnchor, constant: 0)
            .activateAnchors()
        collectionView.backgroundColor = .white
    }
    
    override func setupBinding() {
//        vc.navigationController?.navigationBar.isHidden = true
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: vc, action: #selector(vc.buttonAction(_:)))
        collectionView.delegate = vc
        collectionView.dataSource = vc
        backgroundColor = .white 
        
        
    }
    
}



/*
let flowLayout = UICollectionViewFlowLayout()
let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
collectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)

collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
collectionView.delegate = self
collectionView.dataSource = self
collectionView.backgroundColor = UIColor.cyanColor()

self.view.addSubview(collectionView)
*/

