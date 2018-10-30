//
//  PhotoGridView.swift
//  Explog
//
//  Created by minjuniMac on 24/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class PhotoGridView: BaseView<PhotoGridViewController> {
    var collectionView = UICollectionView(collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .white
        $0.register(cell: PhotoGridCell.self)
    }
    
    lazy var dismissBarButton = UIBarButtonItem(
        barButtonSystemItem: .stop,
        target: vc, action:
        #selector(vc.dismissBarButtonAction(_:)))
    
    lazy var doneBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: vc, action: #selector(vc.doneBarButtonAction(_:)))
    
    // AVPhotoCaptureOutput produces a memory leak when initialized
    // https://forums.developer.apple.com/thread/70449
    var imagePickerViewController = UIImagePickerController().then {
        $0.modalPresentationStyle = .overCurrentContext
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            $0.sourceType = .camera
        }else {
            $0.sourceType = .photoLibrary // for simulrator
        }
    }
    
    
    
    struct UI {
        static var cellItemSpacing: CGFloat = 2
        static var cellSize = CGSize(width: (UIScreen.main.bounds.width / 3) - UI.cellItemSpacing,
                                     height: UIScreen.main.bounds.height / 6)
        static var cellMargin: CGFloat = 1
        
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubviews([collectionView])
        
        collectionView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        collectionView.delegate = vc
        collectionView.dataSource = vc
        vc.navigationItem.leftBarButtonItem = dismissBarButton
        vc.navigationItem.rightBarButtonItem = doneBarButton
        imagePickerViewController.delegate = vc
    }
    
    func doneButtonEnable(order: Bool) {
        switch order {
        case true:
            doneBarButton.tintColor = nil
            doneBarButton.isEnabled = order
        case false:
            doneBarButton.tintColor = UIColor.gray.withAlphaComponent(0.5)
            doneBarButton.isEnabled = order
        }
    }
}
