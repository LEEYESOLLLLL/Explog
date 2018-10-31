//
//  SettingViewController.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit



final class SettingViewController: BaseViewController {
    lazy var v = SettingView(controlBy: self)
    
    
    override func loadView() {
        super.loadView()
        view = v 
    }
}

extension SettingViewController {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
}

// MARK: UITableViewDataSource - for Header
extension SettingViewController {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SettingView.UI.sectionHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeue(SettingHeaderView.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? SettingHeaderView,
            let section = Section(rawValue: section) else {
                return
        }
        header.sectionTitle.text = section.sectionString   
    }
    
}

// MARK: UITableViewDataSource - for Cell
extension SettingViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .account:     return Account.allCases.count
        case .information: return Information.allCases.count
        case .support:     return Support.allCases.count
        case .logout:      return Logout.allCases.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(SettingCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .account:
            cell.textLabel?.text = Account.allCases[indexPath.row].rawValue
        case .information:
            cell.textLabel?.text = Information.allCases[indexPath.row].rawValue
        case .support:
            cell.textLabel?.text = Support.allCases[indexPath.row].rawValue
        case .logout:
            cell.textLabel?.text = Logout.allCases[indexPath.row].rawValue
        }
        
    }
    
}
