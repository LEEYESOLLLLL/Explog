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
    let collectionView: UICollectionView = UICollectionView(frame: UI.collectionViewFrame, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setupUI() {
        collectionView
        
    }
    
    override func setupBinding() {
        vc.navigationController?.navigationBar.isHidden = true
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
