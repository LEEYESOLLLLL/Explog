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
        let cv = UICollectionView.init(collectionViewLayout: flowLayout)
        return cv
    }()
    
    var parallaxNSLayoutConstraints: NSLayoutConstraint?
    override func setupUI() {
        collectionView.register(cell: MainFeedCollectionViewCell.self)
        addSubviews([upperScrollView, collectionView])
        upperScrollView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor, constant: 0)
            .leadingAnchor(to: leadingAnchor, constant: 0)
            .trailingAnchor(to: trailingAnchor, constant: 0)
            .heightAnchor(constant: scrollViewWidthAndHeight.height)
            .bottomAnchor(to: collectionView.topAnchor, constant: 0)
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
            imageview.center = imagePoint
            imageview.bounds.size = imageSize
            return imageview
        }
        upperScrollView.addSubviews(images)
        
        collectionView
            .topAnchor(to: upperScrollView.bottomAnchor, identifer: "ParallaxAnchor")
            .bottomAnchor(to: safeAreaLayoutGuide.bottomAnchor, constant: 0)
            .leadingAnchor(to: leadingAnchor, constant: 0)
            .trailingAnchor(to: trailingAnchor, constant: 0)
            .activateAnchors()
        collectionView.backgroundColor = .white
        
        // ParallaxAnChor 할당
        constraints.forEach {
            if $0.identifier == "ParallaxAnchor" {
                parallaxNSLayoutConstraints = $0
            }
        }
    }
    
    override func setupBinding() {
        backgroundColor = .white
        upperScrollView.delegate = vc
        collectionView.delegate = vc
        collectionView.dataSource = vc
    }
    
    
    func coordinate(_ contentOffset: CGPoint, scrollView: UIScrollView) {
        let parallaxDeltaFactor: CGFloat = 0.5
        var defaultFrame = CGRect(
            x: 0,
            y: upperScrollView.frame.origin.y + upperScrollView.frame.height,
            width: upperScrollView.frame.width,
            height: safeAreaLayoutGuide.layoutFrame.height-upperScrollView.frame.height)
        if contentOffset.y >= 0 {
            parallaxNSLayoutConstraints?.constant = -contentOffset.y * parallaxDeltaFactor
//            defaultFrame.origin.y -= contentOffset.y * parallaxDeltaFactor
//            defaultFrame.size.height += contentOffset.y * parallaxDeltaFactor
//            collectionView.frame = defaultFrame

            collectionView.collectionViewLayout.invalidateLayout()
            
            
            
            
            
            print("CollectionView Frame: \(collectionView.frame)")
            // 0~1
            
        }else {
        }
    }
}

