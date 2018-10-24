//
//  PhotosGridController.swift
//  Explog
//
//  Created by minjuniMac on 24/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Photos



final class PhotoGridViewController: BaseViewController {
    static func create() -> PhotoGridViewController {
        let `self` = self.init()
        self.title = "Camera Roll"
        return self
    }
    lazy var v = PhotoGridView(controlBy: self)
    
    static func loadPhotos() -> PHFetchResult<PHAsset> {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        return PHAsset.fetchAssets(with: allPhotosOptions)
    }
    
    lazy var photos = PhotoGridViewController.loadPhotos()
    lazy var imageManager = PHCachingImageManager()
    
    var selectedState: SelectedState = .notSelected {
        didSet {
            switch selectedState {
            case .selected:
                v.doneButtonEnable(order: true)
            case .notSelected:
                v.doneButtonEnable(order: false)
            }
        }
    }
    
    weak var delegate: PassableData?
    
    
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedState = .notSelected
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @objc func dismissBarButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneBarButtonAction(_ sender: UIBarButtonItem) {
        _ = v.collectionView.visibleCells
            .compactMap { $0 as? PhotoGridCell }
            .filter { $0.isSelected }
            .forEach { delegate?.pass(data: $0.imageView.image!) }
        dismiss(animated: true, completion: nil)
    }
}

extension PhotoGridViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoGridCell else {
            return
        }
        selectedState = .selected
        
        let userSelectType = indexPath.item == 0 ? SelectType.camera : SelectType.photo
        switch userSelectType {
        case .camera:
            show(v.imagePickerViewController, sender: nil)
        case .photo:
            collectionView
                .visibleCells
                .compactMap { $0 as? PhotoGridCell }
                .forEach { $0.drawSelectBox(order: false) }
            cell.drawSelectBox(order: true)
        }
    }
    
}
extension PhotoGridViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoGridCell else {
            return
        }
        
        let userSelectType = indexPath.item == 0 ? SelectType.camera : SelectType.photo
        switch userSelectType {
        case .camera:
            cell.configureImagePicker()
        case .photo:
            let asset = photos.object(at: indexPath.item-1)
            cell.configure(asset: asset, imageManger: imageManager)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeue(PhotoGridCell.self, indexPath: indexPath)
    }
}

extension PhotoGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PhotoGridView.UI.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoGridView.UI.cellMargin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return PhotoGridView.UI.cellMargin
    }
}

// for UIImagePickerController Delegate
extension PhotoGridViewController: UINavigationControllerDelegate { }
extension PhotoGridViewController: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.pass(data: image)
        }
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
}



