//
//  StateView.swift
//  Explog
//
//  Created by Minjun Ju on 23/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension ViewControllerStateView {
    enum State  {
        
        case loading
        case error
        case empty
        case initial
        case errorWithRetry(owner: UIViewController, selector: Selector)
    }
}

class ViewControllerStateView: UIView {
    private var loadingIndicator = UIActivityIndicatorView(style: .gray)
    
    private let descriptionLabel = UILabel().then {
        $0.setup(textColor: .darkGray, fontStyle: .body, textAlignment: .center, numberOfLines: 0)
    }
    private let descriptionButton = UIButton().then {
        $0.isUserInteractionEnabled = false
        $0.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct UI {
        static var loadingIndicatorSize = CGSize(
            width: UIScreen.mainWidth,
            height: UIScreen.mainHeight / 6)
        static var rect = CGRect(
            origin: CGPoint.zero,
            size: CGSize(width: UIScreen.mainWidth, height: UIScreen.mainHeight * 0.8))
        static var margin: CGFloat = 8
        static var imageSize: CGSize = CGSize(width: 100, height: 100)
    }
    
    let stateType: State
    
    init(frame: CGRect = CGRect.zero, state: State) {
        self.stateType = state
        super.init(frame: frame)
        
        switch stateType {
        case .loading:
            setupLoadingState()
        case .error:
            setupState(#imageLiteral(resourceName: "error"), description: "Something worng.\n\nCheckout your internect connecting or try agian")
        case .empty:
            setupState(#imageLiteral(resourceName: "empty-folder-512px"), description: "No Trips match your search word")
        case .errorWithRetry(let owner, let selector):
            descriptionButton.isUserInteractionEnabled = true
            descriptionButton.addTarget(owner, action: selector, for: .touchUpInside)
            setupState(#imageLiteral(resourceName: "return-512px"), description: "Something worng.\n\nCheckout your internect connecting or try agian")
        case .initial: break 
        }
    }
}

// MARK: Loading
extension ViewControllerStateView {
    private func setupLoadingState() {
        frame = CGRect(
            origin: CGPoint.zero,
            size: UI.loadingIndicatorSize)
        addSubview(loadingIndicator)
        
        loadingIndicator
            .centerXAnchor(to: centerXAnchor)
            .centerYAnchor(to: centerYAnchor)
            .activateAnchors()
        loadingIndicator.frame.size = CGSize(
            width: bounds.size.height * 0.5,
            height: bounds.size.height * 0.5)
        loadingIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        loadingIndicator.startAnimating()
    }
}

// MARK : Error & Empty 
extension ViewControllerStateView {
    private func setupState(_ image: UIImage, description: String) {
        frame = UI.rect
        
        addSubviews([descriptionLabel, descriptionButton])
        descriptionLabel
            .centerXAnchor(to: centerXAnchor)
            .centerYAnchor(to: centerYAnchor)
            .leadingAnchor(to: leadingAnchor, constant: UI.margin)
            .trailingAnchor(to: trailingAnchor, constant: -UI.margin)
            .activateAnchors()
        
        descriptionButton
            .centerXAnchor(to: centerXAnchor)
            .bottomAnchor(to: descriptionLabel.topAnchor, constant: -UI.margin * 2)
            .dimensionAnchors(size: UI.imageSize)
            .activateAnchors()
        
        descriptionButton.setBackgroundImage(image, for: .normal)
        if case .error = stateType, case .errorWithRetry = stateType {
            let mutatingString = NSMutableAttributedString(
                string: description)
            if let font = UIFont(name: .defaultFontName, size: 24) {
                mutatingString.addAttributes([.font: font.bold()], range: NSRange(location: 0, length: 16))
                descriptionLabel.attributedText = mutatingString
            }
        }else {
            descriptionLabel.text = description
        }
    }
}
