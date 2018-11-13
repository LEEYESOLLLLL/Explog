//
//  ReplyCell.swift
//  Explog
//
//  Created by minjuniMac on 04/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class ReplyCell: UITableViewCell {
    var profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = UI.profileImagesize.width / 2
    }
    
    var usernameLabel = UILabel().then {
        $0.setup(textColor: .black, fontStyle: .headline, textAlignment: .natural, numberOfLines: 1)
    }
    
    var dateLabel = UILabel().then {
        $0.setup(textColor: .gray, fontStyle: .body, textAlignment: .natural, numberOfLines: 1)
    }
    
    var contentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .leading
        $0.sizeToFit()
    }
    
    var contentsLabel = UILabel().then {
        $0.setup(textColor: .black, fontStyle: .headline, textAlignment: .natural, numberOfLines: 0)
        $0.setContentHuggingPriority(UILayoutPriority(rawValue: 800), for: NSLayoutConstraint.Axis.horizontal)
    }
    
    struct UI {
        static var profileImagesize = CGSize(width: UIScreen.mainWidth * 0.16,
                                             height: UIScreen.mainWidth * 0.16)
        static var margin: CGFloat = 8
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        contentView.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    func setupUI() {
        contentView.addSubviews([profileImageView, contentStackView, contentsLabel])
        contentStackView.addArrangedSubviews([usernameLabel, dateLabel])
        
        profileImageView
            .topAnchor(to: contentView.layoutMarginsGuide.topAnchor)
            .leadingAnchor(to: contentView.leadingAnchor, constant: UI.margin)
            .dimensionAnchors(size: UI.profileImagesize)
            .activateAnchors()
        
        contentStackView
            .topAnchor(to: profileImageView.topAnchor)
            .leadingAnchor(to: profileImageView.trailingAnchor, constant: UI.margin)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor)
            .activateAnchors()
        
        contentsLabel
            .topAnchor(to: contentStackView.bottomAnchor, constant: UI.margin*2)
            .bottomAnchor(to: contentView.layoutMarginsGuide.bottomAnchor)
            .leadingAnchor(to: contentStackView.leadingAnchor)
            .trailingAnchor(to: contentStackView.trailingAnchor)
            .activateAnchors()
    }
    func configure(_ model: ReplyModel) {
        guard let author = model.author,
            let imgURL = URL(string: author.imgProfile) else {
            return
        }
        profileImageView.kf.setImage(with: imgURL,
                                     placeholder: UIImage().resizeImage(UI.profileImagesize.width, opaque: false),
                                     options: [.transition(.fade(0.5))],
                                     progressBlock: nil,
                                     completionHandler: nil)
        
        self.usernameLabel.text = author.username
        self.contentsLabel.text = model.content
        self.dateLabel.text = model.createdAt
    }
}
