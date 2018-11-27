//
//  ChangeLanguageCell.swift
//  Explog
//
//  Created by Minjun Ju on 26/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Localize_Swift


final class ChangeLanguageCell: ReportCell {
    typealias LanguageType = ChangeLanguageViewController.LanguageType
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        detailTextLabel?.textColor = .gray 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(_ title: String) {
        super.configure(title)
        if Localize.currentLanguage() == title {
            checkbox.setCheckState(.checked, animated: true)
        }
        
        let locale = NSLocale(localeIdentifier: title)
        textLabel?.text = locale.displayName(forKey: .identifier, value: title) ?? LanguageType.system.rawValue
        detailTextLabel?.text = Localize.displayNameForLanguage(title)
    }
}
