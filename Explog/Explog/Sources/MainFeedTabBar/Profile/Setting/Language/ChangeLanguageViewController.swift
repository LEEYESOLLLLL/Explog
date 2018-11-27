//
//  ChangeLanguageViewController.swift
//  Explog
//
//  Created by Minjun Ju on 26/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import SwiftyBeaver
import Localize_Swift

final class ChangeLanguageViewController: BaseViewController {
    lazy var v = ChangeLanguageView(controlBy: self)
    var availableLanguage: [String]
    var cashedCellIndex: IndexPath!
    
    required init() {
        self.availableLanguage = Localize.availableLanguages(true)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        super.loadView()
        view = v
    }
    
    
}

extension ChangeLanguageViewController {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    @objc func doneButtonAction(_ sneder: UIBarButtonItem) {
        guard let type = LanguageType.section(cashedCellIndex.section) else {
            return
        }
        
        switch type {
        case .system:
            Localize.setCurrentLanguage(Localize.defaultLanguage())
        case .other:
            let selectedLanguage = availableLanguage[cashedCellIndex.row]
            Localize.setCurrentLanguage(selectedLanguage)
        }
        UIApplication.shared.keyWindow?.rootViewController = AppDelegate.setTabBarViewControllers()
    }
}

extension ChangeLanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? ChangeLanguageCell,
            let checkedCell = tableView.cellForRow(at: cashedCellIndex) as? ChangeLanguageCell else {
                return
        }
        
        cashedCellIndex = indexPath
        checkedCell.checkbox.setCheckState(.unchecked, animated: true)
        cell.checkbox.setCheckState(.checked, animated: true)
    }
}



extension ChangeLanguageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return LanguageType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = LanguageType.section(section) else { return 1 }
        switch type {
        case .system: return 1
        case .other:  return availableLanguage.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(ChangeLanguageCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ChangeLanguageCell,
            let type = LanguageType.section(indexPath.section) else {
            return
        }
        
        switch type {
        case .system:
            cell.configure(LanguageType.system.rawValue)
        case .other:
            let referencedAvailableLanguage = availableLanguage[indexPath.row]
            cell.configure(referencedAvailableLanguage)
        }
        
        if cell.checkbox.checkState == .checked {
            cashedCellIndex = indexPath
        }
    }
}

// MARK: UITableView DataSource - for Header 
extension ChangeLanguageViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingView.UI.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeue(SettingHeaderView.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? SettingHeaderView,
            let type = LanguageType.section(section) else {
                return
        }
        header.sectionTitle.text = type.rawValue
    }
    
}
