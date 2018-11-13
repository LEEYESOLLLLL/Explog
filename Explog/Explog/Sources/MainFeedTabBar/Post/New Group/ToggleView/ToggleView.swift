//
//  ToggleView.swift
//  Explog
//
//  Created by minjuniMac on 27/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension ToggleView {
    enum ToggleType {
        case origin
        case spread
    }
}

final class ToggleView: UIView {
    // 상태 toggle, ToggleType, origin, spread
    // 초기화시, 넣어줄 버튼들.
    // 이미지와 타이틀도 함께
    // 토글상태만 주자. 그 속에 있는 버튼의 액션은 해당 VC에서 관리하게 하고
    // 토글 되고, 안되고의 상태는 state프로퍼티로 관리할수 있게 하자.
    
    var state: ToggleType = .origin {
        didSet {
            switch state {
            case .origin:
                toggle(false)
            case .spread:
                toggle(true)
            }
        }
    }
    
    // 버튼, 타이틀, 위치, 정사각형의 한변
    private var elements: [(title: String, button: UIButton)]
    var squreSide: CGFloat
    
    var decoLabel = UILabel().then {
        $0.setup(textColor: .white, fontStyle: .body, textAlignment: .center, numberOfLines: 1)
        $0.font = UIFont.preferredFont(forTextStyle: .body).withSize(30)
        $0.text = "+"
    }
    
    var buttonsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    var titlesStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    var wholeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
    
    init(elements: [(title: String, button: UIButton)], squreSide: CGFloat, color: UIColor) {
        self.elements = elements
        self.squreSide = squreSide
        super.init(frame: CGRect.zero)
        clipsToBounds = true
        layer.cornerRadius = squreSide/2
        backgroundColor = color
        
        initialSetupUI()
        setupBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialSetupUI() {
        addSubview(decoLabel)
        decoLabel
            .centerXAnchor(to: centerXAnchor)
            .centerYAnchor(to: centerYAnchor)
            .activateAnchors()
        layer.opacity = 0.7
    }
    
    func setupBinding() {
        addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureRecognizer(_ sender: UIGestureRecognizer) {
        state = state == .origin ? .spread : .origin
        
    }
    
    @objc func superViewTapGestureAction(_ sender: UITapGestureRecognizer) {
        state = state == .spread ? .origin : .origin
    }
    
    func toggle(_ state: Bool) {
        guard let superView = superview as? PostDetailView else { return }
        switch state {
        case true:
            // 1
            subviews.forEach { $0.removeFromSuperview() }
            
            // 2
            packageingStackView()
            superView.toggleViewWidth.constant = UIScreen.mainWidth - (PostDetailView.UI.margin * 2)
        case false:
            wholeStackView.clearSubViewOfSubViews()
            initialSetupUI()
            superView.toggleViewWidth.constant = PostDetailView.UI.toggleViewSqureSide
        }
        UIView.animate(withDuration: 0.65, delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 0.5,
                       options: [],
                       animations: {
                        self.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    func packageingStackView() {
        addSubview(wholeStackView)
        wholeStackView.addArrangedSubviews([buttonsStackView, titlesStackView])
        elements.forEach {[weak self] (title: String, button: UIButton) in
            guard let strongSelf = self else { return }
            strongSelf.buttonsStackView.addArrangedSubview(button)
            
            let label = UILabel()
            label.setup(textColor: .white, fontStyle: .body, textAlignment: .center, numberOfLines: 1)
            label.text = title
            strongSelf.titlesStackView.addArrangedSubview(label)
        }
        
        wholeStackView
            .topAnchor(to: topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
}

