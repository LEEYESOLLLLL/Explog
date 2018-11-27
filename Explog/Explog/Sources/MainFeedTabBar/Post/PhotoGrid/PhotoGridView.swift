//
//  PhotoGridView.swift
//  Explog
//
//  Created by minjuniMac on 24/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Photos
import Localize_Swift

final class PhotoGridView: BaseView<PhotoGridViewController> {
    var collectionView = UICollectionView(collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = .white
        $0.layer.opacity = 0.0
        $0.register(cell: PhotoGridCell.self)
    }
    
    lazy var dismissBarButton = UIBarButtonItem(
        barButtonSystemItem: .stop,
        target: vc, action:
        #selector(vc.dismissBarButtonAction(_:)))
    
    lazy var doneBarButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: vc,
                                             action: #selector(vc.doneBarButtonAction(_:))).then {
                                                $0.isEnabled = false
    }
    
    // AVPhotoCaptureOutput produces a memory leak when initialized
    // https://forums.developer.apple.com/thread/70449
    var imagePickerViewController = ImagePickerViewController()
    
    var permissionView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var describePermission = UILabel().then {
        $0.setup(textColor: .darkGray, fontStyle: .body, textAlignment: .center, numberOfLines: 0)
        $0.lineBreakMode = .byWordWrapping
        let mutatingString = NSMutableAttributedString(
            string: "Please Allow Photo Access\n\n This allows you to share photos from your library to your camera roll".localized())
        if let font = UIFont(name: .defaultFontName, size: 20) {
            mutatingString.addAttributes([.font: font.bold()],
                                         range: NSRange(location: 0, length: 25))
            $0.attributedText = mutatingString
        }
    }
    
    var permissionButton = UIButton().then {
        $0.setTitle("Continue".localized(), for: .normal)
        $0.setTitleColor(.system(.blue) , for: .normal)
        $0.titleLabel?.font = UIFont(name: .defaultFontName, size: 20)?.bold()
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1
    }
    
    struct UI {
        static var cellItemSpacing: CGFloat = 2
        static var cellSize = CGSize(width: (UIScreen.mainWidth / 3) - UI.cellItemSpacing,
                                     height: UIScreen.mainHeight / 6)
        static var cellMargin: CGFloat = 1
        static var margin: CGFloat = 8
        static var descriptionMargin = (UIScreen.mainWidth / 3) * 0.5
        
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubviews([collectionView, permissionView])
        permissionView.addSubviews([permissionButton, describePermission])
        
        collectionView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        permissionView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        describePermission
            .bottomAnchor(to: permissionButton.topAnchor, constant: -UI.margin)
            .leadingAnchor(to: permissionView.leadingAnchor, constant: UI.descriptionMargin)
            .trailingAnchor(to: permissionView.trailingAnchor, constant: -UI.descriptionMargin)
            .activateAnchors()
        
        permissionButton
            .centerXAnchor(to: permissionView.centerXAnchor)
            .centerYAnchor(to: permissionView.centerYAnchor)
            .widthAnchor(constant: UIScreen.mainWidth/3)
            .activateAnchors()
    }
    
    override func setupBinding() {
        collectionView.delegate = vc
        collectionView.dataSource = vc
        vc.navigationItem.leftBarButtonItem = dismissBarButton
        vc.navigationItem.rightBarButtonItem = doneBarButton
        imagePickerViewController.delegate = vc
        permissionButton.addTarget(vc, action: #selector(vc.permissionButtonAction(_:)), for: .touchUpInside)
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
    
    func permissionAction(type: PrivateAccessLevel) {
        switch type {
        case .granted:
            permissionView.removeFromSuperview()
            vc.photos = PhotoGridViewController.loadPhotos()
            collectionView.reloadData()
            UIView.animate(withDuration: 0.2) { self.collectionView.layer.opacity = 1.0 }
        case .denied, .undetermined, .restricted: break
        }
    }
}
