//
//  LikeCell.swift
//  Explog
//
//  Created by minjuniMac on 05/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class NotiCell: UITableViewCell {
    
    var profileImage = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = UI.profileImageSize.width / 2
    }
    
    var dateLabel = UILabel().then {
        $0.setup(textColor: .gray, fontStyle: .headline, textAlignment: .natural, numberOfLines: 1)
        $0.text = ""
    }
    
    var infoLabel = UILabel().then {
        $0.setup(textColor: .black, fontStyle: .body, textAlignment: .natural, numberOfLines: 0)
        $0.text = ""
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBinding()
    }
    
    struct UI {
        static var profileImageSize = CGSize(width: UIScreen.mainWidth * 0.2,
                                             height: UIScreen.mainWidth * 0.2)
        static var margin: CGFloat = 8
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubviews([profileImage, dateLabel, infoLabel])
        
        profileImage
            .topAnchor(to: contentView.topAnchor, constant: UI.margin)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor)
            .dimensionAnchors(size: UI.profileImageSize)
            .activateAnchors()
        
        dateLabel
            .topAnchor(to: contentView.topAnchor, constant: UI.margin)
            .leadingAnchor(to: profileImage.layoutMarginsGuide.trailingAnchor, constant: UI.margin * 2)
            .trailingAnchor(to: contentView.trailingAnchor, constant: -UI.margin)
            .activateAnchors()
        
        infoLabel
            .topAnchor(to: dateLabel.bottomAnchor, constant: UI.margin)
            .heightAnchor(constant: UI.profileImageSize.height)
            .bottomAnchor(to: contentView.bottomAnchor, constant: -UI.margin)
            .leadingAnchor(to: dateLabel.leadingAnchor)
            .trailingAnchor(to: dateLabel.trailingAnchor)
            .activateAnchors()   
    }
    
    func setupBinding() {
        
    }
    
    func configure(_ model: NotiListModel.NotiInfo) {
        guard let imgURL = URL(string: model.author.imgProfile) else {
            return
        }
        profileImage.kf.setImage(
            with: imgURL,
            placeholder: UIImage().resizeImage(UI.profileImageSize.width, opaque: false),
            options: [.transition(.fade(0.5))],
            progressBlock: nil,
            completionHandler: nil)
        dateLabel.text = model.likedDate
        infoLabel.text = model.author.username + " 님이" + "`\(model.posttitle)`" + "의 여행기를 좋아합니다"
    }
}
