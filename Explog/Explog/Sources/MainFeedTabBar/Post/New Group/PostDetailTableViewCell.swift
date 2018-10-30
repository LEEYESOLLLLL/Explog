//
//  PostDetailTableViewCell.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class PostDetailTableViewCell: UITableViewCell {
    // ImageView, BoldyText, Label..
    var contentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    var contentText = UILabel().then {
        $0.setup(textColor: .black, fontStyle: .body, textAlignment: .natural, numberOfLines: 0)
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
    
    func setupUI() {
        contentView.addSubviews([contentImageView, contentText])
        contentImageView
            .topAnchor(to: contentView.layoutMarginsGuide.topAnchor)
            .bottomAnchor(to: contentView.layoutMarginsGuide.bottomAnchor)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor)
            .activateAnchors()
        
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
    
    func configure(contentType: PostDetailContentType,
                   content: PostDetailModel.PostContent) {
        switch contentType {
        case .txt:
            guard let type = content.type,
                let textType = PostDetailViewController.TextType(rawValue: type),
                let text = content.content else {
                    return
            }
            switch textType {
            case .basic: contentText.font = UIFont.preferredFont(forTextStyle: .body)
            case .highlight: contentText.font = UIFont.preferredFont(forTextStyle: .headline)
            }
            
            
            contentText.text = text
            contentImageView.image = nil
        case .img:
            guard let imgPath = content.photo,
            let imgURL = URL(string: imgPath)  else {
                return
            }
            
//            DispatchQueue.main.async {
            self.contentText.text = nil
                self.contentImageView.kf.indicatorType = .activity
                self.contentImageView.kf.setImage(with: imgURL,
                                             placeholder: nil,
                                             options: [.transition(ImageTransition.fade(1))],
                                             progressBlock: nil,
                                             completionHandler: nil)
            
            
//            }
        
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        contentText.text = nil
//        contentImageView.image = nil
//    }
}
