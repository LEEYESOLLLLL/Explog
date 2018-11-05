//
//  SearchViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya
import Square
import Kingfisher
import BoltsSwift


final class SearchViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    static func create() -> Self {
        let `self` = self.init()
        self.title = "Search"
        self.tabBarItem.image = #imageLiteral(resourceName: "search")
        return self
    }
    
    let provider = MoyaProvider<Search>(plugins:[NetworkLoggerPlugin()])
    let postProvider = MoyaProvider<Post>()
    private var pendingWorkItem: DispatchWorkItem?
    var state: State = .loading {
        didSet {
            switch state {
            case .loading: break
            case .ready: v.searchTableView.reloadData()
            }
        }
    }
    lazy var v = SearchView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.transparentNaviBar(false)
        tabBarController?.tabBar.isHidden = false
    }
}

extension SearchViewController {
    func retrieve(word: String) {
        provider.request(.retrieve(word: word)) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    if let model = try? response.map(FeedModel.self) {
                       strongSelf.state = .ready(model)
                    }
                case false:
                    Square.display("Request Error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadNetwork(word: String, nextPath: String) {
        guard let nextURL = try? nextPath.asURL(),
            let forNextPageQuery = nextURL.query else {
                return
        }
        
        provider.request(.next(word: word, query: forNextPageQuery)) { [weak self] (result) in
            guard let strongSelf = self,
                case .ready(let item) = strongSelf.state else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    if let model = try? response.map(FeedModel.self) {
                        strongSelf.state = .ready(item + model)
                    }
                case false : Square.display("Request Error")
                }
                
            case .failure(let error):
                print(error.localizedDescription, #function)
            }
        }
    }
    
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

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard case .ready(let item) = state,
            item.posts.count > indexPath.row else {
                return
        }
        let postCover = item.posts[indexPath.row]
        let detailViewController = PostDetailViewController.create(editMode: .off, coverData: postCover)
        show(detailViewController, sender: nil)
    }
    
}

// MARK: UITableView Datasource - 1
extension SearchViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let item) = state else { return 0 }
        return item.posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchView.UI.tableViewHeight
    }
}

// MARK: UITableView Datasource - 2
extension SearchViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(SearchCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? SearchCell,
            case .ready(let item) = state,
            let text = v.searchController.searchBar.text else {
            return
        }
        
        let post = item.posts[indexPath.row]
        cell.configure(model: post) { [weak self] (postPK: Int) -> BoltsSwift.Task<LikeModel> in
            guard let strongSelf = self else {
                fatalError()
            }
            return strongSelf.like(postPK, index: indexPath.row)
        }
        
        // LastIndex
        if let next = item.next, item.posts.count - 1 == indexPath.row {
            loadNetwork(word: text ,nextPath: next)
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? FeedTableViewCell)?.coverImage.kf.cancelDownloadTask()
    }
}

extension SearchViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text,
            text.count > 0 else {
            return
        }
        pendingWork(text)
    }
    
    func pendingWork(_ text: String) {
        // Request, trrigering
        pendingWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.retrieve(word: text)
        }
        pendingWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                      execute: newWorkItem)
    }
}
