//
//  SettingProfilePhotoViewController.swift
//  Explog
//
//  Created by MinjunJu on 02/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class SettingProfilePhotoViewController: PhotoGridViewController {
    override func dismissBarButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func doneBarButtonAction(_ sender: UIBarButtonItem) {
        _ = v.collectionView.visibleCells
            .compactMap { $0 as? PhotoGridCell }
            .filter { $0.isSelected }
            .forEach { delegate?.pass(data: $0.imageView.image!) }
        navigationController?.popViewController(animated: true)
    }
}

extension SettingProfilePhotoViewController {
    override public func imagePickerController(_ picker: UIImagePickerController,
                                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.pass(data: image)
        }
        
        picker.dismiss(animated: false) {
            self.navigationController?.popViewController(animated: false)
        }
    }
}


