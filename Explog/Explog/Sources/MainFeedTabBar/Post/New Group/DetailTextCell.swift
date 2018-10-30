//
//  PostDetailTableViewCell.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class DetailTextCell: UITableViewCell {
    // ImageView, BoldyText, Label..
    var contentText = UILabel().then {
        $0.setup(textColor: .black, fontStyle: .body, textAlignment: .natural, numberOfLines: 0)
        $0.lineBreakMode = .byWordWrapping
        $0.adjustsFontForContentSizeCategory = true 
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct UI {
        static var margin: CGFloat = 4
        static var basicFontSize: CGFloat = 18
        static var highlightFontSize: CGFloat = 30
    }
    
    func setupUI() {
        contentView.addSubviews([contentText])
        contentText
            .topAnchor(to: contentView.layoutMarginsGuide.topAnchor)
            .bottomAnchor(to: contentView.layoutMarginsGuide.bottomAnchor)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor)
            .activateAnchors()
    }
    
    
    func setupBinding() {
        
    }
    
    typealias PostDetailContentType = PostDetailViewController.ContentType
    
    func configure(content: PostDetailModel.PostContent) {
        guard let type = content.type,
            let textType = PostDetailViewController.TextType(rawValue: type),
            let text = content.content else {
                return
        }
        switch textType {
        case .basic: contentText.font = UIFont(name: .defaultFontName, size: UI.basicFontSize)
        case .highlight: contentText.font = UIFont(name: .defaultFontName, size: UI.highlightFontSize)?.bold()
        }
        contentText.text = text
        
        
    }
}
