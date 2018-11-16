//
//  ReportCell.swift
//  Explog
//
//  Created by Minjun Ju on 16/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import M13Checkbox


final class ReportCell: UITableViewCell {
    var checkbox: M13Checkbox!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupBinding()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // checkbox 를 누르면, cell 선택하게,
    // cell을 누르면 checkbox 선택하게 로직짜야함..
    func setupUI() {
        checkbox = M13Checkbox(frame: CGRect(x: 0, y: 0,
                                             width: 30,
                                             height: 30))
        checkbox.stateChangeAnimation = .bounce(.fill)
        checkbox.isUserInteractionEnabled = false
        accessoryView = checkbox
    }
    
    func setupBinding() {
        selectionStyle = .none
    }
    
    func configure(_ title: String) {
        textLabel?.text = title
    }
    
}
