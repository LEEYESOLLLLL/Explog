//
//  UploadPhotoView.swift
//  Explog
//
//  Created by minjuniMac on 29/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya

final class UploadPhotoViewController: PhotoGridViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default 
    }
    
    var postPK: Int
    required init(postPK: Int) {
        self.postPK = postPK
        super.init()
    }
    
    static func create(postPK: Int) -> Self {
        let `self` = self.init(postPK: postPK)
        self.title = "Camera Roll"
        return self
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let provider = MoyaProvider<Post>(plugins: [NetworkLoggerPlugin()])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override func dismissBarButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func doneBarButtonAction(_ sender: UIBarButtonItem) {
        // image 가져오고.
        _ = v.collectionView.visibleCells
            .compactMap { $0 as? PhotoGridCell }
            .filter { $0.isSelected }
            .forEach { delegate?.pass(data: $0.imageView.image!) }
    }
}


extension UploadPhotoViewController {
    override public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            delegate?.pass(data: image)
        }
    }
}

extension UploadPhotoViewController: PassableDataDelegate {
    func pass(data: UIImage) {
        provider.request(.photo(postPK: postPK, photo: data)) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true : strongSelf.navigationController?.popViewController(animated: true)
                case false:
                    print("fail to Request: \(#function)")
                }
            case .failure(let error):
                print(error.localizedDescription, "\(#function)")
            }
        }
    }
}
