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
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 1
        
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        let cv = UICollectionView.init(collectionViewLayout: flowLayout)
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
        backgroundColor = .white
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: vc, action: #selector(vc.buttonAction(_:)))
        
        collectionView.delegate = vc
        collectionView.dataSource = vc
        
        collectionView.register(
            CollectionViewHeaderView.self,
            forSupplementaryViewOfKind: "Kind",
            withReuseIdentifier: "HeaderView")
        
        
        
        
    }
}



