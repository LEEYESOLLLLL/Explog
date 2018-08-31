//
//  UIView+LayoutAnchor.swift
//  Explog
//
//  Created by minjuniMac on 8/28/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

extension UIView {
    // View 디버깅시 identifier 사용하면 좋을듯?
    func topAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func topAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0, identifer: String) -> Self {
        let anchor = topAnchor.constraint(equalTo: anchor, constant: constant)
            anchor.identifier = "\(identifer)"
            anchor.isActive = true
        return self
    }
    
    func leadingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func bottomAnchor(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func trailingAnchor(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    func widthAnchor(constant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    func heightAnchor(constant: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
    
    func dimensionAnchors(width widthConstant: CGFloat, height heightConstant: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        return self
    }
    
    func dimensionAnchors(size: CGSize) -> Self {
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
        return self
    }
    
    func centerYAnchor(to anchor: NSLayoutYAxisAnchor) -> Self {
        centerYAnchor.constraint(equalTo: anchor).isActive = true
        return self
    }
    
    func centerXAnchor(to anchor: NSLayoutXAxisAnchor) -> Self {
        centerXAnchor.constraint(equalTo: anchor).isActive = true
        return self
    }
    
    /**
     Don't forget useing it when you develop programmatically UI
     */
    func activateAnchors() {
        translatesAutoresizingMaskIntoConstraints = false
    }
}

extension NSLayoutAnchor {
    
}
