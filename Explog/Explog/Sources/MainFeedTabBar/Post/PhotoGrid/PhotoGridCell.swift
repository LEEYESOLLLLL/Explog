//
//  PhotoGridCell.swift
//  Explog
//
//  Created by minjuniMac on 24/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Photos

extension PhotoGridCell {
    enum State {
        case selected
        case nonSelected
    }
}

final class PhotoGridCell: UICollectionViewCell {
    var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    var representedAssetIdentifier: String!
    
    var state: State = .nonSelected {
        didSet {
            switch state {
            case .selected:
                drawSelectBox(order: true)
            case .nonSelected :
                drawSelectBox(order: false)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews([imageView])
        imageView
            .topAnchor(to: contentView.topAnchor)
            .bottomAnchor(to: contentView.bottomAnchor)
            .leadingAnchor(to: contentView.leadingAnchor)
            .trailingAnchor(to: contentView.trailingAnchor)
            .activateAnchors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(asset: PHAsset, imageManger: PHCachingImageManager) {
        representedAssetIdentifier = asset.localIdentifier
        imageManger.requestImage(
            for: asset,
            targetSize: bounds.size,
            contentMode: .aspectFill,
            options: nil) { [weak self] (image, _) in
                guard let strongSelf = self else { return }
                if strongSelf.representedAssetIdentifier == asset.localIdentifier {
                    strongSelf.imageView.image = image
                }
        }
        state = isSelected ? .selected : .nonSelected
    }
    
    func configureImagePicker() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "camera")
        backgroundColor = UIColor.gray.withAlphaComponent(0.6)
    }
    
    func drawSelectBox(order: Bool) {
        if order {
            isSelected = false
            contentView.layer.borderColor = UIColor.appStyle.cgColor
            contentView.layer.borderWidth = 5
        }else {
            contentView.layer.borderColor = nil
            contentView.layer.borderWidth = 0
        }
    }
}


