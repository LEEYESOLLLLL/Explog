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

extension NotiViewController {
    enum State {
        case loading
        case ready(NotiListModel)
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
            switch state {
            case .loading: break
            case .ready: DispatchQueue.main.async { self.v.likeTableView.reloadData() }
            }
        }
    }
    
    lazy var v = NotiView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
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
                }
            }
            .continueWith { [weak self] _ in
                guard let self = self else {
                    return
                }
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
                    do {
                        let model = try response.map(NotiListModel.self)
                        self.state = .ready(model)
                        self.v.likeTableView.reloadData()
                    }catch {
                    }
                case false : Square.display("Request Error..")
                }
            case .failure(let error):
                Square.display("Weak Internet Connection")
                print(error.localizedDescription)
            }
        }
    }
}

extension NotiViewController {
    func goNext(path: String) {
        guard let nextURL = try? path.asURL(),
            let query = nextURL.query else {
                return
        }
        
        provider.request(.next(query: query)) { [weak self] result in
            guard let self = self,
                case .ready(let item) = self.state  else {
                    return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    do {
                        let model = try response.map(NotiListModel.self)
                        if let combind = item + model {
                            self.state = .ready(combind)
                        }
                    }catch {
                        print("\(#function), Fail to Convert Model")
                    }
                case false :
                    print("\(#function), Request Error")
                    
                }
            case .failure(let error): print(error.localizedDescription, #function)
            }
        }
    }
}

extension NotiViewController {
    // For rendering
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.likeTableView.reloadData()
    }
}

extension NotiViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotiViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let item) = state,
            let results = item.results else {
                return 0
        }
        
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(NotiCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? NotiCell,
            case .ready(let item) = state,
            let results = item.results,
            results.count > indexPath.row else {
                return
        }
        
        let info = results[indexPath.row]
        cell.configure(info)
        if let next = item.next, results.count - 1 == indexPath.row {
            self.goNext(path: next)
        }
    }
}

