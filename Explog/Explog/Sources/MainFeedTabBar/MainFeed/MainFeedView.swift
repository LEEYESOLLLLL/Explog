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
//    let collectionView: UICollectionView = UICollectionView(
//        frame: UI.collectionViewFrame,
//        collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var collectionView: UICollectionView = {
        
        
        let cvlayout = UICollectionViewFlowLayout()

        cvlayout.minimumLineSpacing = 0
        cvlayout.minimumInteritemSpacing = 10
        cvlayout.scrollDirection = .vertical
        cvlayout.estimatedItemSize = CGSize(
            width: bounds.width/2 - 10,
            height: bounds.height-(safeAreaInsets.top+safeAreaInsets.bottom))
//        cvlayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(
            frame: UI.collectionViewFrame,
            collectionViewLayout: cvlayout)
        
        
        return cv
    }()
    
    
    
    
    
    override func setupUI() {
        collectionView.register(cell: MainFeedCollectionViewCell.self)
        
        
        addSubviews([collectionView])
        
        // 제약조건을 추가하기 위해서는 부모가 있어야함..
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
//        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        collectionView.backgroundColor = .white
        

        
        
        
        
    }
    
    override func setupBinding() {
//        vc.navigationController?.navigationBar.isHidden = true
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: vc, action: #selector(vc.buttonAction(_:)))
        collectionView.delegate = vc
        collectionView.dataSource = vc
        
        
        
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
