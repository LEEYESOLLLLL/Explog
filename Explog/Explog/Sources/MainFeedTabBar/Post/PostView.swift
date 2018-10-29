//
//  PostView.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class PostView: BaseView<PostViewController> {
    var containerScrollView = UIScrollView().then {
        $0.backgroundColor = . white
        $0.contentInsetAdjustmentBehavior = .never 
    }
    
    var contentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    var coverImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.image = #imageLiteral(resourceName: "account-background")
    }
    
    var darkBlurView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .dark)
        $0.layer.opacity = 0.2
        $0.backgroundColor = .darkText
    }
    
    var topIconStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.spacing = UI.stackViewSpacing
        $0.clipsToBounds = false
    }
    
    var dismissButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(#imageLiteral(resourceName: "cancel-1"), for: .normal)
        $0.dimensionAnchors(size: UI.iconSize).activateAnchors()
    }
    
    var createPostButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(#imageLiteral(resourceName: "checkBox"), for: .normal)
        $0.dimensionAnchors(size: UI.iconSize).activateAnchors()
    }
    
    var titleCounterLable = UILabel().then {
        $0.setup(textColor: .white, fontStyle: .body, textAlignment: .center, numberOfLines: 1)
        $0.adjustsFontSizeToFitWidth = true
        $0.text = "0/50"
        $0.lineBreakMode = .byCharWrapping
    }
    
    var changeCoverImageButton = UIButton().then {
        $0.setTitle("  Cover", for: [.normal, .highlighted])
        $0.setTitleColor(.gray, highlightedStateColor: .darkGray)
        $0.setImage(#imageLiteral(resourceName: "Library"), for: .normal)
    }
    
    var titleTextView = UITextView().then {
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.textAlignment = .center
        $0.isEditable = true
        $0.font = UIFont(name: .defaultFontName, size: 30)?.bold()
        $0.text = "Let's go on a trip!"
        $0.enablesReturnKeyAutomatically = false
    }
    
    var dateStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.alignment = .fill
        $0.spacing = 20
    }
    
    var startDateButton = UIButton().then {
        $0.setTitle("\(Date().convertedString())", for: .normal)
        $0.setTitleColor(.white, highlightedStateColor: .gray)
        $0.tag = 0
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    var endDateButton = UIButton().then {
        $0.setTitle("\(Date().convertedString())", for: .normal)
        $0.setTitleColor(.white, highlightedStateColor: .gray)
        $0.tag = 1
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    var tripInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .fill
        $0.spacing = 20
    }
    
    var continentButton = UIButton().then {
        $0.setTitle("Asia", for: .normal)
        $0.setTitleColor(.white, highlightedStateColor: .gray)
        
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    struct UI {
        static var titleImageViewHeight: CGFloat = UIScreen.mainHeight/2
        static var iconSize: CGSize = UIScreen.main.bounds.size * 0.026
        static var topButtonMargin: CGFloat = 6
        static var counterLableSize = CGSize(width: 50, height: 50)
        static var stackViewSpacing: CGFloat = (UIScreen.mainWidth - UIScreen.mainWidth*0.3) / 2
        static var margin: CGFloat = 8
        static var textViewHeight = UIScreen.mainHeight/9
        static var tripInfoMargin = UIScreen.mainWidth/10
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubview(containerScrollView)
        containerScrollView.addSubview(contentView)
        contentView.addSubviews([coverImageView, darkBlurView, topIconStackView, changeCoverImageButton, titleTextView, tripInfoStackView])
        topIconStackView.addArrangedSubviews([dismissButton, titleCounterLable, createPostButton])
        dateStackView.addArrangedSubviews([startDateButton, endDateButton])
        tripInfoStackView.addArrangedSubviews([dateStackView, continentButton])
        
        containerScrollView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
        
        contentView
            .topAnchor(to: containerScrollView.topAnchor)
            .bottomAnchor(to: containerScrollView.bottomAnchor)
            .leadingAnchor(to: containerScrollView.leadingAnchor)
            .trailingAnchor(to: containerScrollView.trailingAnchor)
            .dimensionAnchors(size: UIScreen.main.bounds.size)
            .activateAnchors()
        
        coverImageView
            .topAnchor(to: contentView.topAnchor)
            .leadingAnchor(to: contentView.leadingAnchor)
            .trailingAnchor(to: contentView.trailingAnchor)
            .heightAnchor(constant: UI.titleImageViewHeight)
            .activateAnchors()
        
        darkBlurView
            .topAnchor(to: coverImageView.topAnchor)
            .leadingAnchor(to: coverImageView.leadingAnchor)
            .trailingAnchor(to: coverImageView.trailingAnchor)
            .bottomAnchor(to: coverImageView.bottomAnchor)
            .activateAnchors()
        
        topIconStackView
            .topAnchor(to: contentView.layoutMarginsGuide.topAnchor)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor, constant: UI.topButtonMargin)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor, constant: -UI.topButtonMargin)
            .heightAnchor(constant: UI.iconSize.height)
            .activateAnchors()
        
        changeCoverImageButton
            .topAnchor(to: coverImageView.bottomAnchor, constant: UI.margin)
            .leadingAnchor(to: coverImageView.layoutMarginsGuide.leadingAnchor)
            .activateAnchors()
        
        titleTextView
            .topAnchor(to: topIconStackView.bottomAnchor, constant: UI.margin*3)
            .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor)
            .trailingAnchor(to: contentView.layoutMarginsGuide.trailingAnchor)
            .heightAnchor(constant: UI.textViewHeight)
            .activateAnchors()
        
        tripInfoStackView
            .topAnchor(to: titleTextView.bottomAnchor, constant: UI.margin)
            .leadingAnchor(to: titleTextView.leadingAnchor, constant: UI.tripInfoMargin)
            .trailingAnchor(to: titleTextView.trailingAnchor, constant: -UI.tripInfoMargin)
            .bottomAnchor(greaterThanOrEqualTo: coverImageView.layoutMarginsGuide.bottomAnchor, constant: -UI.tripInfoMargin*1.8)
            .activateAnchors()
    }
    
    override func setupBinding() {
        dismissButton            .addTarget(vc, action: #selector(vc.dismissButtonAction(_:)), for: .touchUpInside)
        createPostButton         .addTarget(vc, action: #selector(vc.createPostButtonAction(_:)), for: .touchUpInside)
        changeCoverImageButton   .addTarget(vc, action: #selector(vc.changeCoverImageButtonAction(_:)), for: .touchUpInside)
        startDateButton          .addTarget(vc, action: #selector(vc.dateButtonAction(_:)), for: .touchUpInside)
        endDateButton            .addTarget(vc, action: #selector(vc.dateButtonAction(_:)), for: .touchUpInside)
        continentButton          .addTarget(vc, action: #selector(vc.continentButtonAction(_:)), for: .touchUpInside)
        titleTextView.delegate = vc
    }
    
    func updateTitleCouterLable(text count: String, color: UIColor) {
        titleCounterLable.text = "\(count)/50"
        titleCounterLable.textColor = color
    }
    
    func currentPostCoverInformation() -> PostInformation? {
        guard let startData = startDateButton.titleLabel?.text,
            let endData = endDateButton.titleLabel?.text,
            let continentText = continentButton.titleLabel?.text  else {
                return nil
        }
        
        let continentRawValue = ContinentPickerAlertViewController
            .ContinentType
            .allCases
            .filter { $0.string == continentText }
            .compactMap { $0.rawValue }
        
        guard let continent = continentRawValue.first else {
            return nil
        }
        
        guard let img = coverImageView.image else {
            return nil
        }
        
        return PostInformation(
            title: titleTextView.text,
            startData: startData,
            endData: endData,
            continent: String(continent+1), // the first continent number is mapped since 1
            coverImg: img)
    }
}


struct PostInformation {
    var title: String
    var startData: String
    var endData: String
    var continent: String
    var coverImg: UIImage
}

