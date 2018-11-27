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
    override init(style: CellStyle, reuseIdentifier: String?) {
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
        guard let type = SettingViewController.Feature(byLocalizedString: text) else {
            return
        }
        
        textLabel?.text = text
        switch type {
        case .cashed:
            ImageCache.default.calculateDiskCacheSize {[weak self] (n: UInt) in
                guard let self = self else { return }
                self.detailTextLabel?.text = ByteCountFormatter.string(fromByteCount: Int64(n), countStyle: .file)
            }
        case .language:
            accessoryType = .disclosureIndicator
        }
    }
}

extension SettingCell {
    func information(_ text: String) {
        guard let type = SettingViewController.Information(byLocalizedString: text) else {
            return
        }
        
        textLabel?.text = text
        switch type {
        case .app_version:
            textLabel?
                .topAnchor(to: contentView.layoutMarginsGuide.topAnchor)
                .centerYAnchor(to: contentView.centerYAnchor)
                .leadingAnchor(to: contentView.layoutMarginsGuide.leadingAnchor)
                .bottomAnchor(to: contentView.layoutMarginsGuide.bottomAnchor)
                .activateAnchors()
            
            AppInfo.latest { [weak self] (version) in
                guard let self = self  else { return }
                self.detailTextLabel?.numberOfLines = 2
                self.detailTextLabel?.text = "Installed: " + version + "\nLatest: " + AppInfo.versionString()
            }
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

