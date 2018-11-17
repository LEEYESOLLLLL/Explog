//
//  ReportView.swift
//  Explog
//
//  Created by Minjun Ju on 16/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit

final class ReportView: BaseView<ReportViewController> {
    var tableView = UITableView().then {
        $0.register(cell: ReportCell.self)
        $0.rowHeight = UI.rowHeight
        $0.estimatedRowHeight = 100
        $0.separatorStyle = .none
        
    }
    
    lazy var backButton = UIBarButtonItem(
        image: #imageLiteral(resourceName: "back-24pk").withRenderingMode(.alwaysOriginal),
        style: .plain,
        target: vc,
        action: #selector(vc.backButtonAction(_:)))
    
    lazy var doneButton = UIBarButtonItem(
        barButtonSystemItem: .done,
        target: vc,
        action: #selector(vc.doneButtonAction(_:))).then {
            $0.tintColor = .black
            $0.isEnabled = false
    }
    
    struct UI {
        static var rowHeight: CGFloat = 60
    }
    
    override func setupUI() {
        backgroundColor = .white
        addSubviews([tableView])
        
        tableView
            .topAnchor(to: safeAreaLayoutGuide.topAnchor)
            .bottomAnchor(to: bottomAnchor)
            .leadingAnchor(to: leadingAnchor)
            .trailingAnchor(to: trailingAnchor)
            .activateAnchors()
    }
    
    override func setupBinding() {
        doneButton.isEnabled = false
        tableView.delegate = vc
        tableView.dataSource = vc
        vc.navigationItem.leftBarButtonItem = backButton
        vc.navigationItem.rightBarButtonItem = doneButton
    }
    
    func selectedReportType() -> String? {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let cell = tableView.cellForRow(at: indexPath) as? ReportCell,
            let text = cell.textLabel?.text else {
                return nil
        }
        return text   
    }
    
}
