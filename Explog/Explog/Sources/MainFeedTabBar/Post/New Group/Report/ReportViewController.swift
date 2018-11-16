//
//  ReportViewController.swift
//  Explog
//
//  Created by Minjun Ju on 16/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Firebase
import Square

final class ReportViewController: BaseViewController  {
    var postPK: Int
    init(postPK: Int) {
        self.postPK = postPK
        super.init()
        
    }
    
    required init() { fatalError("init() has not been implemented") }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    lazy var v = ReportView(controlBy: self)
    var ref: DatabaseReference!
    override func loadView() {
        super.loadView()
        view = v
    }
    
    
}



extension ReportViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
}


extension ReportViewController {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        guard let token = KeychainService.token,
        let selectedType = v.selectedReportType() else {
            return
        }
        /**
         UUID is purpose that is not to override for reports list
         */
        let reportRef = ref
            .child(FBDatabaseKey.report.rawValue)
            .child("user_token " + token)
            .child(UUID().uuidString)
        
        let item = ReportModel(postPK, selectedType).dictionary()
        reportRef.setValue(item)
        dismiss(animated: true) {
            Square.display("Successfully flagged")
        }
    }
}

extension ReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        v.doneButton.isEnabled = true
        return indexPath
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard ReportList.allCases.count > indexPath.row,
            let cell = tableView.cellForRow(at: indexPath) as? ReportCell else {
                return
        }
        tableView
            .visibleCells
            .compactMap{ $0 as? ReportCell }
            .forEach { $0.checkbox.setCheckState(.unchecked, animated: true) }
        
        switch cell.checkbox.checkState {
        case .mixed: break
        case .checked:
            cell.checkbox.setCheckState(.unchecked, animated: true)
        case .unchecked:
            cell.checkbox.setCheckState(.checked, animated: true)
        }
    }
}

// MARK: UITableViewDataSource - 1
extension ReportViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReportList.allCases.count
    }
}

// MARK: UITableViewDataSource - 2 For Reusable
extension ReportViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(ReportCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard ReportList.allCases.count > indexPath.row,
            let cell = cell as? ReportCell else {
                return
        }
        
        cell.configure(ReportList.allCases[indexPath.row].rawValue)
    }
}
