//
//  SettingViewController.swift
//  Explog
//
//  Created by minjuniMac on 31/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Square
import Kingfisher
import MessageUI
import AcknowList

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

// MARK: TableView Delegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // for Flash
        guard let section = Section(rawValue: indexPath.section),
        let cell = tableView.cellForRow(at: indexPath) as? SettingCell,
        let cellText = cell.textLabel?.text else {
            return
        }
        
        switch section {
        case .account:
            guard let type = Account(rawValue: cellText) else {
                return
            }
            switch type {
            case .profile_setting: navigationController?.pushViewController(SettingProfileViewController.create(), animated: true)
            case .change_password: navigationController?.pushViewController(ChangePasswordViewController.create(), animated: true)
            }
            
        case .feature:
            Square.display("Delegate Cache", message: "Do you want to delete stored cache?",
                           alertActions: [.cancel(message: "Cancel"), .destructive(message: "Delete")]) { (_, index) in
                if index == 1 {
                    KingfisherManager.shared.cache.allClear()
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
            
        case .information:
            guard let type = Information(rawValue: cellText) else {
                    return
                }
            
            switch type {
            case .app_version: break
            case .opensource_license:
                let viewController = CustomAcknowListViewController(fileNamed: "Pods-Explog-acknowledgements")
                navigationController?.pushViewController(viewController, animated: true)
            }
        case .support:
            if MFMailComposeViewController.canSendMail() {
                let composeVC = MFMailComposeViewController.create(owner: self)
                self.present(composeVC, animated: true, completion: nil)
            }else {
                Square.display("Unable to send an email. if you didn't configure Email Account,  need to configure Email Account.")
            }
            
        case .logout:
            Square.display("Warning", message: "Are you sure you wnat to log out?",
                           alertActions: [.cancel(message: "Cencel"), .destructive(message: "OK")]) { (alertAction, index) in
                if index == 1 {
                    if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
                        let tabBarController = rootViewController as? UITabBarController {
                        KeychainService.allClear()
                        rootViewController.dismiss(animated: false) {
                            tabBarController.selectedViewController = tabBarController.viewControllers?.first!
                        }
                    }
                }
            }
        }
    }
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
        case .feature:     return Feature.allCases.count
        case .information: return Information.allCases.count
        case .support:     return Support.allCases.count
        case .logout:      return Logout.allCases.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(SettingCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section),
            let cell = cell as? SettingCell else {
                return
        }
        
        switch section {
        case .account:     cell.account(Account.allCases[indexPath.row].rawValue)
        case .feature:     cell.feature(Feature.allCases[indexPath.row].rawValue)
        case .information: cell.openSource(Information.allCases[indexPath.row].rawValue)
        case .support:     cell.support(text: Support.allCases[indexPath.row].rawValue)
        case .logout:      cell.logout(Logout.allCases[indexPath.row].rawValue)
        }
        
    }
    
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
