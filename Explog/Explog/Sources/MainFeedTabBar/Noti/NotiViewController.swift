//
//  LikeViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya
import Square
import BoltsSwift
import SwiftyBeaver

extension NotiViewController {
    // loading, paging, empty, error
    typealias NotiInfo = NotiListModel.NotiInfo
    enum State {
        case loading
        case populated(notifications: NotiListModel)
        case paging(notifications: NotiListModel, nextPage: String)
        case retryOnError(Error?, message: String?)
        
        var currentNotifications: [NotiInfo]? {
            switch self {
            case .populated(let notifications):
                return notifications.results
            case .paging(let notifications, _):
                return notifications.results
            default:
                return nil
            }
        }
    }
}

final class NotiViewController: BaseViewController {
    static func create() -> Self {
        let `self` = self.init()
        self.title = "Noti"
        self.tabBarItem.image = #imageLiteral(resourceName: "noti-1")
        
        return self
    }
    let provider = MoyaProvider<Noti>(plugins: [NetworkLoggerPlugin()])
    var state: State = .loading {
        didSet {
            managingState()
        }
    }
    
    lazy var v = NotiView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
    private func managingState() {
        switch state {
        case .loading:
            v.setup(footerView: ViewControllerStateView(state: .loading))
        case .populated:
            v.setup(footerView: nil)
        case .paging:
            v.setup(footerView: ViewControllerStateView(state: .loading))
        case .retryOnError(let error, let message):
            SwiftyBeaver.error(error.debugDescription, message ?? "")
            v.setup(footerView: ViewControllerStateView(state: .retryOnError(owner: self, selector: #selector(retry(_:)) )))
        }
        v.likeTableView.reloadData()
    }
    
    @objc func retry(_ sender: UIButton) {
        viewWillAppear(true)
        viewDidAppear(true)
    }
}

extension NotiViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.likeTableView.reloadData()
    }
}

// MARK: Reset Badge Number
extension NotiViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetBadge()
            .continueWith { [weak self] task in
                guard let self = self else {
                    return
                }
                if task.completed {
                    self.tabBarItem.badgeValue = nil
                    UIApplication.shared.applicationIconBadgeNumber = 0
                } else {
                    self.state = .retryOnError(task.error, message: nil)
                }
            }
            .continueWith { [weak self] _ in
                guard let self = self else {
                    return
                }
                self.state = .loading
                self.notiList()
        }
    }
    
    private func resetBadge() -> BoltsSwift.Task<Void> {
        let source = TaskCompletionSource<Void>()
        provider.request(.reset) { (result) in
            switch result {
            case .success: source.set(result: ())
            case .failure(let error): source.set(error: error)
            }
        }
        return source.task
    }
    
    private func notiList() {
        provider.request(.list) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    guard let model = try? response.map(NotiListModel.self) else {
                        SwiftyBeaver.debug("No Covert NotiListModel")
                        return
                    }
                    
                    if let nextPage = model.next {
                        self.state = .paging(notifications: model, nextPage: nextPage)
                    }else {
                        self.state = .populated(notifications: model)
                    }
                case false :
                    self.state = .retryOnError(nil, message: "Request Error..")
                }
            case .failure(let error):
                self.state = .retryOnError(error, message: nil)
            }
        }
    }
}

// MARK: Paging
extension NotiViewController {
    func goNext(path: String) {
        guard let nextURL = try? path.asURL(),
            let query = nextURL.query else {
                return
        }
        
        provider.request(.next(query: query)) { [weak self] result in
            guard let self = self,
                case .paging(let currentNotifications, _) = self.state  else {
                    return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    guard let model = try? response.map(NotiListModel.self),
                        let combindedModel = currentNotifications + model else {
                            SwiftyBeaver.debug("No combind NotiListModel")
                        return
                    }
                    if let nextPage = model.next {
                        self.state = .paging(notifications: combindedModel, nextPage: nextPage)
                    }else {
                        self.state = .populated(notifications: combindedModel)
                    }
                    
                case false :
                    self.state = .retryOnError(nil, message: "NextPage Request Error")
                }
            case .failure(let error):
                self.state = .retryOnError(error, message: nil)
            }
        }
    }
}

// MARK: TableView Delegate
extension NotiViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: TableView DataSource 
extension NotiViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let notifications = state.currentNotifications else {
            return 0
        }
        
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(NotiCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? NotiCell,
            let notifications = state.currentNotifications,
            notifications.count > indexPath.row else {
                return
        }
        
        let info = notifications[indexPath.row]
        cell.configure(info)
        
        if case .paging(_ , let nextPage) = state, notifications.count > indexPath.row {
            self.goNext(path: nextPage)
            
        }
    }
}

