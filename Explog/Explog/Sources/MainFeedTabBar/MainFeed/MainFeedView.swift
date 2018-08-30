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
    var upperScrollView: UIScrollView = {
        let _scv = UIScrollView()
        return _scv
    }()
    
    let scrollViewWidthAndHeight: (width: CGFloat, height: CGFloat) = (width: UIScreen.main.bounds.width, height: 200)
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 1
        
        // Header
        let cv = UICollectionView.init(collectionViewLayout: flowLayout)
        return cv
    }()
    
    override func setupUI() {
        collectionView.register(cell: MainFeedCollectionViewCell.self)
        addSubviews([collectionView, upperScrollView])
        upperScrollView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor, constant: 0)
            .leadingAnchor(to: leadingAnchor, constant: 0)
            .trailingAnchor(to: trailingAnchor, constant: 0)
            .heightAnchor(constant: scrollViewWidthAndHeight.height)
            .activateAnchors()
    
        collectionView
            .topAnchor(to: upperScrollView.bottomAnchor, constant: 0)
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
        upperScrollView.contentSize = CGSize(
            width: scrollViewWidthAndHeight.width*6/2 + scrollViewWidthAndHeight.width/2,
            height: scrollViewWidthAndHeight.height)
        
        let images = [#imageLiteral(resourceName: "Asia"), #imageLiteral(resourceName: "Europe"), #imageLiteral(resourceName: "North America"), #imageLiteral(resourceName: "South America"), #imageLiteral(resourceName: "Africa"), #imageLiteral(resourceName: "Austrailia")].enumerated().map{ (offset:Int, image: UIImage) -> UIImageView in
            let imageview = UIImageView(image: image)
            let imageSize = CGSize(width: 150, height: 150)
            let frame = UIScreen.main.bounds
            
            let imagePoint = CGPoint(x:frame.midX*(CGFloat(offset+1)) , y: scrollViewWidthAndHeight.height/2)
            imageview.center = imagePoint
            imageview.bounds.size = imageSize
            return imageview
        }
    
        upperScrollView.addSubviews(images)
        
        collectionView.delegate = vc
        collectionView.dataSource = vc
    }
        
}

