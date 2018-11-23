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
import SwiftyBeaver


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
    let postProvider = MoyaProvider<Post>(plugins:[NetworkLoggerPlugin()])
    private var pendingWorkItem: DispatchWorkItem?
    var state: State = .loading {
        didSet {
            manageState()
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
        view.layoutIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.searchController.searchBar.becomeFirstResponder()
    }
}

extension SearchViewController {
    private func manageState() {
        switch state {
        case .loading:       v.setup(footerView: ViewControllerStateView(state: .loading))
        case .populated:     v.setup(footerView: nil)
        case .paging(_ , _): v.setup(footerView: ViewControllerStateView(state: .loading))
        case .empty:         v.setup(footerView: ViewControllerStateView(state: .empty))
        case .error(let error, let message):
            SwiftyBeaver.error(error?.localizedDescription ?? "", message)
            v.setup(footerView: ViewControllerStateView(state: .error))
        }
        v.searchTableView.reloadData()
    }
}

extension SearchViewController {
    private func retrieve(word: String) {
        provider.request(.retrieve(word: word.trimmingCharacters(in: .whitespacesAndNewlines))) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    guard let model = try? response.map(FeedModel.self) else {
                        return
                    }
                    guard model.posts.count != 0 else {
                        self.state = .empty
                        return
                    }
                    if let nextPage = model.next, model.hasNext {
                        self.state = .paging(posts: model, nextPage: nextPage)
                    }else {
                        self.state = .populated(posts: model)
                    }
                    
                case false:
                    self.state = .error(error: nil, message: "\(#function)")
                }
            case .failure(let error):
                self.state = .error(error: error, message: "Server Error for Searching Request")
            }
        }
    }
    
    private func loadNetwork(word: String, nextPath: String) {
        guard let nextURL = try? nextPath.asURL(),
            let forNextPageQuery = nextURL.query else {
                return
        }
        provider.request(.next(word: word, query: forNextPageQuery)) { [weak self] (result) in
            guard let self = self,
                case .paging(let item, _) = self.state else {
                    return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    guard let model = try? response.map(FeedModel.self) else {
                        self.state = .error(error: nil, message: "No data converting")
                        return
                    }
                    if let nextPage = model.next {
                        self.state = .paging(posts: item + model, nextPage: nextPage)
                    }else {
                        self.state = .populated(posts: item + model)
                    }
                    
                case false:
                    self.state = .error(error: nil, message: "\(#function)")
                }
                
            case .failure(let error):
                self.state = .error(error: error, message: "Server Error for Searching Request Next Pageing")
            }
        }
    }
}

// MARK: Like
extension SearchViewController {
    @discardableResult
    private func like(_ postPrivateKey: Int, index: Int) -> BoltsSwift.Task<LikeModel> {
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
                        self.state = .populated(posts: copy)
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
        guard state.currentPosts.count > indexPath.row else {
                return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        let postCover = state.currentPosts[indexPath.row]
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
        return state.currentPosts.count
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
            let text = v.searchController.searchBar.text else {
                return
        }
        
        let post = state.currentPosts[indexPath.row]
        cell.configure(model: post) { [weak self] (postPK: Int) -> BoltsSwift.Task<LikeModel> in
            guard let self = self else {
                fatalError()
            }
            return self.like(postPK, index: indexPath.row)
        }
        
        if case .paging(_, let nextPage) = state, state.currentPosts.count - 1 == indexPath.row {
            loadNetwork(word: text, nextPath: nextPage)
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
    
    // Request, trigering
    func pendingWork(_ text: String) {
        pendingWorkItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else {
                return
            }
            self.state = .loading
            self.retrieve(word: text)
        }
        pendingWorkItem = newWorkItem
        DispatchQueue.main.asyncAfter(
            deadline: .now() + .milliseconds(250),
            execute: newWorkItem)
    }
}
