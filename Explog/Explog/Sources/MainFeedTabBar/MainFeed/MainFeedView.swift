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
    
    let scrollViewWidthAndHeight = (width: UIScreen.main.bounds.width,
                                    height: UIScreen.main.bounds.height/4,
                                    scaleFactor: CGFloat(0.8))
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        
        
        // Header
        let cv = UICollectionView.init(collectionViewLayout: flowLayout)
        //cv.isPagingEnabled = true
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
        
        upperScrollView.contentSize = CGSize(
            width: scrollViewWidthAndHeight.width*6/2 + scrollViewWidthAndHeight.width/2,
            height: scrollViewWidthAndHeight.height)
        
        let images = [#imageLiteral(resourceName: "Asia"), #imageLiteral(resourceName: "Europe"), #imageLiteral(resourceName: "North America"), #imageLiteral(resourceName: "South America"), #imageLiteral(resourceName: "Africa"), #imageLiteral(resourceName: "Austrailia")].enumerated().map{ (offset:Int, image: UIImage) -> UIImageView in
            let imageview = UIImageView(image: image)
            let imageSize = CGSize(
                width: scrollViewWidthAndHeight.height * scrollViewWidthAndHeight.scaleFactor,
                height: scrollViewWidthAndHeight.height * scrollViewWidthAndHeight.scaleFactor)
            let imagePoint = CGPoint(
                x: scrollViewWidthAndHeight.width/2*(CGFloat(offset+1)),
                y: scrollViewWidthAndHeight.height/2)
            print("point is \(imagePoint)")
            imageview.center = imagePoint
            imageview.bounds.size = imageSize
            return imageview
        }
        upperScrollView.addSubviews(images)
        
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
        upperScrollView.delegate = vc
        
        collectionView.delegate = vc
        collectionView.dataSource = vc
    }
    
}

