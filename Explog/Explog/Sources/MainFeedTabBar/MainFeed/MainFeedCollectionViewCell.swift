//
//  MainFeedCollectionViewCell.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SnapKit

final class MainFeedCollectionViewCell: UICollectionViewCell {
    
    var lable: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(lable)
        
        lable.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        lable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
