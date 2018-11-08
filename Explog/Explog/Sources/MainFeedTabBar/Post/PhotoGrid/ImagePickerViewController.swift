//
//  ImagePickerViewController.swift
//  Explog
//
//  Created by minjuniMac on 08/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

final class ImagePickerViewController: UIImagePickerController {
    var deviceAuthorizationState = AVCaptureDevice.authorizationStatus(for: .video)
    
    var dismissButton = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "cancel-1").resizeImage(UI.imageSize, opaque: false), for: .normal)
    }
    
    var permissionView = UIView().then {
        $0.backgroundColor = .black
    }
    
    var describePermission = UILabel().then {
        $0.setup(textColor: .white, fontStyle: .body, textAlignment: .center, numberOfLines: 0)
        $0.lineBreakMode = .byWordWrapping
        let mutatingString = NSMutableAttributedString(
            string: "Please Allow Camera Access\n\n This allows you to share taking your photos")
        if let font = UIFont(name: .defaultFontName, size: 21) {
            mutatingString.addAttributes([.font: font.bold()],
                                         range: NSRange(location: 0, length: 26))
            $0.attributedText = mutatingString
        }
    }
    
    var permissionButton = UIButton().then {
        $0.setTitle("Continue", for: .normal)
        $0.setTitleColor(.white , for: .normal)
        $0.titleLabel?.font = UIFont(name: .defaultFontName, size: 20)?.bold()
        $0.layer.borderColor = UIColor.gray.cgColor
        $0.layer.borderWidth = 1
    }
    
    struct UI {
        static var imageSize: CGFloat = 22
        static var margin: CGFloat = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        setupBinding()
        
    }
    
    func setupUI() {
        view.addSubviews([permissionView])
        permissionView.addSubviews([dismissButton, permissionButton, describePermission])
        
        permissionView
            .topAnchor(to: view.topAnchor)
            .leadingAnchor(to: view.leadingAnchor)
            .trailingAnchor(to: view.trailingAnchor)
            .bottomAnchor(to: view.bottomAnchor)
            .activateAnchors()
        
        dismissButton
            .topAnchor(to: permissionView.layoutMarginsGuide.topAnchor, constant: UI.margin)
            .leadingAnchor(to: permissionView.layoutMarginsGuide.leadingAnchor, constant: UI.margin)
            .activateAnchors()
        
        describePermission
            .bottomAnchor(to: permissionButton.topAnchor, constant: -PhotoGridView.UI.margin)
            .leadingAnchor(to: permissionView.leadingAnchor, constant: PhotoGridView.UI.descriptionMargin)
            .trailingAnchor(to: permissionView.trailingAnchor, constant: -PhotoGridView.UI.descriptionMargin)
            .activateAnchors()
        
        permissionButton
            .centerXAnchor(to: permissionView.centerXAnchor)
            .centerYAnchor(to: permissionView.centerYAnchor)
            .widthAnchor(constant: UIScreen.main.bounds.width/3)
            .activateAnchors()
        
        permissionAction(type: deviceAuthorizationState)
    }
    
    func setupBinding() {
        permissionButton.addTarget(self, action: #selector(permissionButtonAction(_:)), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(dismissButtonAction(_:)), for: .touchUpInside)
        
    }
    
    func permissionAction(type: AVAuthorizationStatus) {
        switch type {
        case .authorized:
            sourceType = .camera
            modalPresentationStyle = .overCurrentContext
            permissionView.removeFromSuperview()
        case .denied, .notDetermined, .restricted:
            break
        }
    }
    
    @objc func permissionButtonAction(_ sender: UIButton) {
        switch deviceAuthorizationState {
        case .authorized: break
        case .denied: UIApplication.shared.openSettings()
        case .notDetermined, .restricted:
            AVCaptureDevice.requestAccess(for: .video) { (allowance) in
                switch allowance {
                case true : DispatchQueue.main.async { self.permissionAction(type: .authorized) }
                case false : DispatchQueue.main.async { UIApplication.shared.keyWindow?.rootViewController!.dismiss(animated: true, completion: nil) }
                }
            }
        }
    }
    
    @objc func dismissButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
