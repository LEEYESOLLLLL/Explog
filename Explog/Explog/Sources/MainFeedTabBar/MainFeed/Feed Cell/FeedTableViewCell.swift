//
//  InSideTableViewCell.swift
//  Explog
//
//  Created by minjuniMac on 8/30/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher
import BoltsSwift

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
    
    var likeButton = UIButton()
    var likeState: LikeState = .original {
        didSet {
            switch likeState {
            case .like: likeButton.setImage(#imageLiteral(resourceName: "newLike-red-512px").resizeImage(UI.likeButtonSize, opaque: false), for: .normal)
            case .original: likeButton.setImage(#imageLiteral(resourceName: "newLike-white-512px").resizeImage(UI.likeButtonSize, opaque: false), for: .normal)
                
            }
        }
    }
    
    
    struct UI {
        static var cellSpacing: CGFloat = 1
        static var labelSpacing: CGFloat = 16
        static var likeButtonSize: CGFloat = 22
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
        likeButton.addTarget(self, action: #selector(likeButtonAction(_:)), for: .touchUpInside)
    }
    
    
    var likeClosure: ( (_ postPK: Int) -> BoltsSwift.Task<LikeModel> )?
    var model: Post?
    func configure(model: Post,
                   likeAction: @escaping (_ postPK: Int) -> BoltsSwift.Task<LikeModel>) {
        guard let title = model.title,
            let startDate = model.startDate,
            let endDate = model.endDate,
            let imgPath = model.img,
            let url = URL(string: imgPath) else {
                return
        }
        self.model = model
        if let userPK = KeychainService.pk {
            let liked = model.liked.compactMap{ String($0) }
            likeState = liked.contains(userPK) ? .like : .original
        }else {
            likeState = .original
        }
        coverImage.kf.indicatorType = .activity
        coverImage.kf.setImage(with: url,
                               placeholder: nil,
                               options:     [.transition(ImageTransition.fade(1))],
                               progressBlock: nil,
                               completionHandler: nil)
        titleLabel.text = title
        dateLabel.text = "\(startDate) ~ \(endDate)"
        authorLabel.text = model.author.username
        numberOfLikeLabel.text = String(model.numLiked)
        
        // Like Closuer
        likeClosure = likeAction
    }
    
}

extension FeedTableViewCell {
    @objc func likeButtonAction(_ sender: UIButton) {
        guard let likeClosure = likeClosure,
            let postPK = model?.pk else {
            return
        }
        reloadLike()
        likeClosure(postPK)
            .continueWith { (task) -> Void in
            // Error Handlring
        }
    }
    
    func reloadLike() {
        if let userPK = KeychainService.pk,
            let convertUserPK = Int(userPK),
            let model = self.model {
            let isLiked = model.liked.contains(convertUserPK)
            let numLike = isLiked ? max(model.numLiked - 1, 0) : model.numLiked + 1
            likeState = isLiked ? .original : .like
            numberOfLikeLabel.text = String(numLike)
        }
    }
}
