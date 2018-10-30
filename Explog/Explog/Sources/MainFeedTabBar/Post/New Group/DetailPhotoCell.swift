//
//  DetailPhotoCell.swift
//  Explog
//
//  Created by minjuniMac on 30/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class DetailPhotoCell: UITableViewCell {
    var contentImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        // scaleAspectFill Cell 전체가 꽉참
        //
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
    }
    
    func setupUI() {
        contentView.addSubviews([contentImageView])
        contentImageView
            .topAnchor(to: contentView.topAnchor, constant: UI.margin)
            .bottomAnchor(to: contentView.bottomAnchor, constant: -UI.margin)
            .leadingAnchor(to: contentView.leadingAnchor)
            .trailingAnchor(to: contentView.trailingAnchor)
            .activateAnchors()
    }
    
    func setupBinding() {
        
    }
    
    typealias PostDetailContentType = PostDetailViewController.ContentType
    
    func configure(content: PostDetailModel.PostContent) {
        guard let imgPath = content.photo,
            let imgURL = URL(string: imgPath) else {
                return
        }
        
        self.contentImageView.kf.indicatorType = .activity
        self.contentImageView.kf.setImage(with: imgURL,
                                          placeholder: nil,
                                          options: [.transition(ImageTransition.fade(1))],
                                          progressBlock: nil,
                                          completionHandler: nil)
    }
}
