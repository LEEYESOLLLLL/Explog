//
//  InSideTableViewCell.swift
//  Explog
//
//  Created by minjuniMac on 8/30/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class FeedTableViewCell: UITableViewCell {
    var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }
    var coverImage = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    var darkBlurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .dark)
        $0.layer.opacity = 0.1
        $0.backgroundColor = .darkText
    }
    
    var titleLabel = UILabel().then {
        $0.setup(textColor :.white, fontStyle: .headline, textAlignment: .center, numberOfLines: 0)
    }
    var dateLabel = UILabel().then {
        $0.setup(textColor :.white, fontStyle: .headline, textAlignment: .center, numberOfLines: 1)
    }
    var authorLabel = UILabel().then {
        $0.setup(textColor :.white, fontStyle: .headline, textAlignment: .center, numberOfLines: 1)
        
    }
    
    var numberOfLikeLabel = UILabel().then {
        $0.setup(textColor :.white, fontStyle: .body, textAlignment: .center, numberOfLines: 0)
        $0.text = "100"
    }
    
    var descriptionCoverStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.alignment = .fill
    }
    
    var likeButton = UIButton().then {
        $0.setTitle("Like", for: .normal)
        $0.setTitleColor(.red, for: .normal)
    }
    
    
    struct UI {
        static var cellSpacing: CGFloat = 1
        static var labelSpacing: CGFloat = 16
        
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
        contentView.addSubview(containerView)
        containerView.addSubviews([coverImage, darkBlurView, descriptionCoverStackView, numberOfLikeLabel, likeButton])
        descriptionCoverStackView.addArrangedSubviews([titleLabel, dateLabel, authorLabel])

        containerView
            .topAnchor(to: contentView.topAnchor, constant: UI.cellSpacing)
            .bottomAnchor(to: contentView.bottomAnchor, constant: -UI.cellSpacing)
            .leadingAnchor(to: contentView.leadingAnchor, constant: UI.cellSpacing)
            .trailingAnchor(to: contentView.trailingAnchor, constant: -UI.cellSpacing)
            .activateAnchors()
        
        coverImage
            .topAnchor(to: containerView.topAnchor)
            .bottomAnchor(to: containerView.bottomAnchor)
            .leadingAnchor(to: containerView.leadingAnchor)
            .trailingAnchor(to: containerView.trailingAnchor)
            .activateAnchors()
        
        darkBlurView
            .topAnchor(to: containerView.topAnchor)
            .bottomAnchor(to: containerView.bottomAnchor)
            .leadingAnchor(to: containerView.leadingAnchor)
            .trailingAnchor(to: containerView.trailingAnchor)
            .activateAnchors()
        
        descriptionCoverStackView
            .topAnchor(to: containerView.layoutMarginsGuide.topAnchor)
            .bottomAnchor(to: containerView.layoutMarginsGuide.bottomAnchor)
            .leadingAnchor(to: containerView.layoutMarginsGuide.leadingAnchor)
            .trailingAnchor(to: containerView.layoutMarginsGuide.trailingAnchor)
            .activateAnchors()
        
        numberOfLikeLabel
            .trailingAnchor(to: containerView.layoutMarginsGuide.trailingAnchor)
            .bottomAnchor(to: containerView.layoutMarginsGuide.bottomAnchor)
            .activateAnchors()
        
        likeButton
            .topAnchor(to: numberOfLikeLabel.topAnchor)
            .trailingAnchor(to: numberOfLikeLabel.leadingAnchor, constant: -8)
            .bottomAnchor(to: numberOfLikeLabel.bottomAnchor)
            .activateAnchors()
        
    }
    
    func setupBinding() {
        // Like Button Call Back 어떻게 처리할건지 고민해놓자.
        // Like Button 좋아요 눌러졌을때, 그렇지 않을때 상태 관리 어떻게 할건지 고민하자.
        
    }
    
    func configure(title: String,
                   imagePath: String,
                   startDate: String,
                   endDate: String,
                   author: String,
                   numberOflike: Int) {
        titleLabel.text = title
        if let url = URL(string: imagePath) {
            coverImage.kf.indicatorType = .activity
            coverImage.kf.setImage(with: url,
                                   placeholder: nil,
                                   options:     [.transition(ImageTransition.fade(1))],
                                   progressBlock: nil,
                                   completionHandler: nil)
        }
        
        dateLabel.text = "\(startDate) ~ \(endDate)"
        authorLabel.text = author
        numberOfLikeLabel.text = String(numberOflike)
    }
}
