//
//  MainFeedTableViewController.swift
//  Explog
//
//  Created by minjuniMac on 09/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import CaseContainer
import Moya
import BoltsSwift
import Kingfisher
import Square
import SwiftyBeaver


final class FeedTableViewController: ParallaxTableViewController {
    let provider = MoyaProvider<Feed>(plugins: [NetworkLoggerPlugin()])
    let postProvider = MoyaProvider<Post>(plugins: [NetworkLoggerPlugin()])
    
    var state: State = .initial {
        didSet {
            managingState()
        }
    }
    
    lazy var triggerInitialization = UIRefreshControl().then {
        $0.addTarget(self, action: #selector(triggerInitializationAction(_:)), for: .valueChanged)
    }
    
    /**
     tableview's tag is used to identify requesting number of continent
     */
    static func createWith(title: String, owner: ParallaxViewDelegate, tag: Int) -> Self {
        let `self` = self.init()
        _ = self.tableView.then {
            $0.delegate = self
            $0.dataSource = self
            $0.register(cell: FeedTableViewCell.self)
            $0.tag = tag
        }
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.delegate = owner
        self.title = title
        return self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .initial
    }
    
    func setupUI() {
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        DispatchQueue.main.async {
            self.state = .loading
            self.networkServiceWith(continent: self.tableView.tag)
        }
    }
    
    func setupBinding() {
        tableView.refreshControl = triggerInitialization
    }
    
    @objc func triggerInitializationAction(_ sender: UIRefreshControl) {
        state = .initial
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    private func managingState() {
        switch state {
        case .initial:
            setupUI()
            setupBinding()
        case .loading:
            tableView.tableFooterView = ViewControllerStateView(state: .loading)
        case .populated:
            tableView.tableFooterView = nil
        case .paging:
            tableView.tableFooterView = ViewControllerStateView(state: .loading)
        case .errorWithRetry:
            tableView.tableFooterView = ViewControllerStateView(state: .errorWithRetry(owner: self, selector: #selector(retry)))
        }
        tableView.reloadData()
    }
    @objc func retry(_ sender: UIButton) {
        triggerInitializationAction(triggerInitialization)
    }
}

// MARK: Networking
extension FeedTableViewController {
    func networkServiceWith(continent: Int) {
        provider.request(.category(continent: continent)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                guard let model = try? response.map(FeedModel.self) else {
                    SwiftyBeaver.error("No Convert FeedModel")
                    self.state = .errorWithRetry
                    return
                }
                
                if let nextPage = model.next {
                    self.state = .paging(feedModel: model, nextPage: nextPage)
                }else {
                    self.state = .populated(feedModel: model)
                }
            case.failure(let error) :
                SwiftyBeaver.error("No Connect Internet: \(String(describing: error.errorDescription))")
                self.state = .errorWithRetry
            }
        }
    }
    
    func loadNetwork(continent: Int, nextPage nextURL: String) {
        guard let nextURL = try? nextURL.asURL(),
            let NextPageQuery = nextURL.query else  {
                return
        }
        provider.request(.next(continent: continent, query: NextPageQuery)) { [weak self] result in
            guard let self = self, case .paging(let item, _) = self.state else {
                    return
            }
            switch result {
            case .success(let response):
                guard let model = try? response.map(FeedModel.self) else {
                    SwiftyBeaver.error("No Convert FeedModel")
                    self.state = .errorWithRetry
                    return
                }
                
                if let nextPage = model.next {
                    self.state = .paging(feedModel: item + model, nextPage: nextPage)
                }else {
                    self.state = .populated(feedModel: item + model)
                }
                
            case .failure(let error):
                SwiftyBeaver.error("No Convert FeedModel: \(String(describing: error.errorDescription))")
                self.state = .errorWithRetry
            }
        }
    }
}

// MARK: Like
extension FeedTableViewController {
    @discardableResult
    func like(_ postPrivateKey: Int, index: Int) -> BoltsSwift.Task<LikeModel> {
        let taskCompletionSource = TaskCompletionSource<LikeModel>()
        postProvider.request(.like(postPK: postPrivateKey)) { [weak self] (result) in
            guard let self = self,
                case .populated(let item) = self.state else {
                    return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode{
                case true :
                    if let likeModel = try? response.map(LikeModel.self) {
                        var copy = item
                        copy.posts[index].modifiedLike(model: likeModel)
                        self.state = .populated(feedModel: copy)
                        taskCompletionSource.set(result: likeModel)
                    }
                case false :
                    taskCompletionSource.set(error: LikeError.failConvertingModel)
                }
            case .failure(let error):
                taskCompletionSource.set(error: error)
            }
        }
        return taskCompletionSource.task
    }
}

// MARK: TableViewDelegate
extension FeedTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard case .populated(let item) = state,
            item.posts.count > indexPath.row else {
                return
        }
        if KeychainService.token != nil {
            // Call detailView
            let postCover = item.posts[indexPath.row]
            let postDetailViewController = PostDetailViewController.create(editMode: .off, coverData: postCover)
            show(postDetailViewController, sender: nil)
        }else {
            Square.display("Require Login", message: "Do you want to go to the login screen?",
                           alertActions: [.cancel(message: "Cancel"), .default(message: "OK")]) { [weak self] (alertAction, index) in
                            guard let self = self else { return }
                            if index == 1 {
                                let authController = AuthViewController()
                                self.present(authController, animated: true, completion: nil)
                            }
            }
        }
    }
}

// MARK: TableView DataSource - 1
extension FeedTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return state.currentFeedModel.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }
    
}

// MARK: TabbleView DataSource - 2
extension FeedTableViewController {
    // MARK: Call sequence - 1
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(FeedTableViewCell.self)
    }
    
    // MARK: Call sequence - 2
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedTableViewCell, state.currentFeedModel.count > indexPath.row else {
                return
        }
        let post = state.currentFeedModel[indexPath.row]
        cell.configure(model: post) { [weak self] (postPK: Int) -> BoltsSwift.Task<LikeModel> in
            guard let self = self else {
                fatalError()
            }
            return self.like(postPK, index: indexPath.row)
        }
        
        // Last Index
        if case .paging(_, let nextPage) = state,
            state.currentFeedModel.count - 1 == indexPath.row {
            loadNetwork(continent: tableView.tag, nextPage: nextPage)
        }
    }
    
    // MARK: Call sequence - 3
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? FeedTableViewCell)?.coverImage.kf.cancelDownloadTask()
    }
}
