//
//  CustomAcknowListViewController.swift
//  Explog
//
//  Created by minjuniMac on 03/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import AcknowList

final class CustomAcknowListViewController: AcknowListViewController {
    
    
    lazy var backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal),
                                     style: .plain,
                                     target: self,
                                     action: #selector(backButtonAction(_:)))
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: indexPath, animated: animated)
        }
        
        navigationItem.setLeftBarButton(backButton, animated: true)
    }
}
