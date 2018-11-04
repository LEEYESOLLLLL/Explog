//
//  SettingTableViewCell.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Kingfisher

final class SettingCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont(name: .defaultFontName, size: 16)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingCell {
    func account(_ text: String) {
        textLabel?.text = text
        accessoryType = .disclosureIndicator
    }
}


extension SettingCell {
    func feature(_ text: String) {
        textLabel?.text = text
        ImageCache.default.calculateDiskCacheSize {[weak self] (n: UInt) in
            guard let strongSelf = self else { return }
            strongSelf.detailTextLabel?.text = ByteCountFormatter.string(fromByteCount: Int64(n), countStyle: .file)
        }
    }
}


extension SettingCell {
    func openSource(_ text: String) {
        guard let type = SettingViewController.Information(rawValue: text) else {
            return
        }
        
        textLabel?.text = text
        switch type {
        case .app_version:
            detailTextLabel?.text = AppInfo.versionString()
        case .opensource_license:
            accessoryType = .disclosureIndicator
        }
    }
}

extension SettingCell {
    func support(text: String) {
        textLabel?.text = text 
    }
}


extension SettingCell {
    func logout(_ text: String) {
        textLabel?.text = text
        textLabel?.textColor = .red
        textLabel?.font = UIFont(name: .defaultFontName, size: 16)?.bold()
    }
}

