//
//  ReplyView.swift
//  Explog
//
//  Created by minjuniMac on 04/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit



final class ReplyView: BaseView<ReplyViewController> {
    var uploadState: UploadState = .enabled {
        didSet {
            switch uploadState {
            case .enabled:
                createReplyButton.isEnabled = true
                createReplyButton.layer.opacity = 1.0
            case .unable:
                createReplyButton.isEnabled = false
                createReplyButton.layer.opacity = 0.4
            }
        }
    }
    lazy var backButton = UIBarButtonItem(
        image: #imageLiteral(resourceName: "cancel-1").resizeImage(UI.backButtonSize, opaque: false).withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: vc,
        action: #selector(vc.backButtonAction(_:)))
    
    var replyTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.layer.opacity = 0.0
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 88
        $0.register(cell: ReplyCell.self)
    }
    
    var inputContainer = UIView().then {
        $0.backgroundColor = .white
        let lineView = UIView(frame: CGRect(x: 0, y: 1, width: UIScreen.mainWidth, height: 1))
        lineView.backgroundColor = .darkGray
        $0.addSubview(lineView)
    }
    
    var inputTextView = UITextView().then {
        $0.font = UIFont(name: .defaultFontName, size: 18)
        $0.textColor = .gray
        $0.textAlignment = .natural
        $0.text = "input your comments🐳"
        $0.isEditable = true
        $0.isUserInteractionEnabled = true
        
    }
    
    var createReplyButton = UIButton().then {
        $0.setTitle("Post", for: [.normal, .highlighted])
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .appStyle
        $0.clipsToBounds = true
        $0.layer.cornerRadius = (UI.postButtonwidth / 2) * 0.5
    }
    
    
    lazy var inputContainerViewBottomConstraint = NSLayoutConstraint(
        item: inputContainer,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: self,
        attribute: .bottom,
        multiplier: 1.0,
        constant: 0)
    
    struct UI {
        static var backButtonSize: CGFloat = 22
        static var margin: CGFloat = 8
        static var postButtonwidth: CGFloat = UIScreen.mainWidth / 4.5
        static var inputviewHeight: CGFloat = UIScreen.mainHeight * 0.10
    }
    override func setupUI() {
        backgroundColor = .white
        addSubviews([replyTableView, inputContainer])
        inputContainer.addSubviews([inputTextView, createReplyButton])
        replyTableView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .bottomAnchor(to: inputContainer.topAnchor)
            .activateAnchors()
        
        
        inputContainer
            .topAnchor(to: replyTableView.bottomAnchor)
            .leadingAnchor(to: replyTableView.leadingAnchor)
            .trailingAnchor(to: replyTableView.trailingAnchor)
            .heightAnchor(constant: UI.inputviewHeight)
            .activateAnchors()
        NSLayoutConstraint.activate([inputContainerViewBottomConstraint]) // For Keyboard
        
        inputTextView
            .topAnchor(to: inputContainer.topAnchor, constant: UI.margin)
            .bottomAnchor(to: inputContainer.bottomAnchor, constant: -UI.margin)
            .leadingAnchor(to: inputContainer.leadingAnchor, constant: UI.margin)
            .trailingAnchor(to: createReplyButton.leadingAnchor)
            .activateAnchors()
        
        createReplyButton
            .topAnchor(to: inputTextView.topAnchor, constant: UI.margin)
            .bottomAnchor(to: inputTextView.bottomAnchor, constant: -UI.margin)
            .leadingAnchor(to: inputTextView.trailingAnchor)
            .trailingAnchor(to: inputContainer.trailingAnchor, constant: -UI.margin)
            .widthAnchor(constant: UI.postButtonwidth)
            .activateAnchors()
    }
    
    override func setupBinding() {
        replyTableView.delegate = vc
        replyTableView.dataSource = vc
        inputTextView.delegate = vc
        createReplyButton.addTarget(vc, action: #selector(vc.createReplyButtonAction(_:)), for: .touchUpInside)
        setupNavigationBar()
        
    }
    
    func setupNavigationBar() {
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationController?.navigationBar.barTintColor = .appStyle
        vc.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        vc.navigationItem.title = "Comments"
        vc.navigationController?.navigationBar.barStyle = .black
    }
    
    /**
     for dynamic Label Size
     */
    func dynamicReload() {
        replyTableView.reloadData()
        UIView.animate(withDuration: 0.15) { self.replyTableView.layer.opacity = 1.0 }
    }
    
    func terminationEffect() {
        guard case .ready(let item) = vc.state else {
            return
        }
        replyTableView.reloadData()
        replyTableView.scrollToRow(at: IndexPath(item: item.count - 1, section: 0),
                                   at: .bottom, animated: true)
        endEditing(true)       
    }
}
