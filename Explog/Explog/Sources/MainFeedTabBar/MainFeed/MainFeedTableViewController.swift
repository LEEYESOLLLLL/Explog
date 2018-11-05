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


final class FeedTableViewController: ParallaxTableViewController {
    let provider = MoyaProvider<Feed>()//.(plugins: [NetworkLoggerPlugin(])
    let postProvider = MoyaProvider<Post>()
    var state: State = .loading {
        didSet {
            switch state {
            case .loading: setupUI()
            case .ready:   tableView.reloadData()
            case .error :  print("\(#function): cause error~")
            }
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
        state = .loading
        setupBinding()
    }
    
    func setupUI() {
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension
        DispatchQueue.main.async { self.networkServiceWith(continent: self.tableView.tag) }
    }
    
    func setupBinding() {
        tableView.refreshControl = triggerInitialization
    }
    
    @objc func triggerInitializationAction(_ sender: UIRefreshControl) {
        state = .loading
        tableView.reloadData()
        sender.endRefreshing()
    }
}

// MARK: Networking
extension FeedTableViewController {
    func networkServiceWith(continent: Int) {
        provider.request(.category(continent: continent)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                do {
                    strongSelf.state = .ready(try response.map(FeedModel.self))
                }catch {
                    strongSelf.state = .error
                }
            case.failure(let error) :
                strongSelf.state = .error
                print(error.localizedDescription)
            }
        }
    }
    
    func loadNetwork(continent: Int, query nextpageQuery: String) {
        provider.request(.next(continent: continent, query: nextpageQuery)) { [weak self] result in
            guard let strongSelf = self,
                case .ready(let item) = strongSelf.state else {
                return
            }
            switch result {
            case .success(let response):
                do {
                    let convertedData = try response.map(FeedModel.self)
                    strongSelf.state = .ready(item + convertedData)
                }catch {
                    print(error.localizedDescription)
                    strongSelf.state = .error
                }
            case .failure(let error):
                print(error.localizedDescription)
                strongSelf.state = .error
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
            guard let strongSelf = self,
                case .ready(let item) = strongSelf.state else {
                    return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode{
                case true :
                    if let likeModel = try? response.map(LikeModel.self) {
                        var copy = item
                        copy.posts[index].modifiedLike(model: likeModel)
                        strongSelf.state = .ready(copy)
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
        guard case .ready(let item) = state,
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
                            guard let strongSelf = self else { return }
                            if index == 1 {
                                let authController = AuthViewController()
                                strongSelf.present(authController, animated: true, completion: nil)
                            }
            }
        }
    }
}

// MARK: TableView DataSource
extension FeedTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let item) = state else { return 0 }
        return item.posts.count
    }
    
    // MARK: Call sequence - 2
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? FeedTableViewCell,
            case .ready(let item) = state else {
                return
        }
        let post = item.posts[indexPath.row]
        cell.configure(model: post) { [weak self] (postPK: Int) -> BoltsSwift.Task<LikeModel> in
            guard let strongSelf = self else {
                fatalError()
            }
            return strongSelf.like(postPK, index: indexPath.row)
        }
    }
    
    // MARK: Call sequence - 3
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? FeedTableViewCell)?.coverImage.kf.cancelDownloadTask()
    }
    
    // MARK: Call sequence - 1
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case .ready(let item) = state else { fatalError() }
        let cell = tableView.dequeue(FeedTableViewCell.self)
        if let next = item.next,
            indexPath.row == item.posts.count - 1,
            let nextURL = try? next.asURL(),
            let queryOfNextPage = nextURL.query {
            loadNetwork(continent: tableView.tag, query: queryOfNextPage)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3.6
    }
}
