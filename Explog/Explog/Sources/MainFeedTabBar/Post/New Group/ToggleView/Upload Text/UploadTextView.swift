//
//  HighlighteTextView.swift
//  Explog
//
//  Created by minjuniMac on 29/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class UploadTextView: BaseView<UploadTextViewController> {
    var textView = UITextView().then {
        $0.textColor = .darkGray
        $0.resignFirstResponder()
        $0.text = "Tell your friends about your trip!"
    }
    
    lazy var backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal),
                                     style: .plain,
                                     target: vc,
                                     action: #selector(vc.backButtonAction(_:)))
    lazy var uploadTextButton = UIBarButtonItem(image: #imageLiteral(resourceName: "paper-black-512-px").resizeImage(UI.donButtonSize, opaque: false).withRenderingMode(.alwaysOriginal),
                                                style: .plain,
                                                target: vc,
                                                action: #selector(vc.uploadTextButtonAction(_:)))
    
    struct UI {
        static var highlightFontsize: CGFloat = 35
        static var basicFontsize: CGFloat = 30
        static var donButtonSize: CGFloat = 26
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubview(textView)
        
        textView
            .topAnchor(to: layoutMarginsGuide.topAnchor)
            .bottomAnchor(to: layoutMarginsGuide.bottomAnchor)
            .leadingAnchor(to: layoutMarginsGuide.leadingAnchor)
            .trailingAnchor(to: layoutMarginsGuide.trailingAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        vc.navigationItem.hidesBackButton = false
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.rightBarButtonItem = uploadTextButton
        vc.navigationItem.title = "Add Text"
        
        let fontType: UIFont.TextStyle = vc.textType == .basic ? .body : .headline
        let fontSize = vc.textType == .basic ? UI.basicFontsize : UI.highlightFontsize
        textView.font = UIFont.preferredFont(forTextStyle: fontType).withSize(fontSize)
        textView.delegate = vc
        
        // 1. registe Notification
        NotificationCenter.default.addObserver(vc,
                                               selector: #selector(vc.keyboardWillShow(noti:)) ,
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(vc,
                                               selector: #selector(vc.keyboardWillHide(noti:)) ,
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
}
