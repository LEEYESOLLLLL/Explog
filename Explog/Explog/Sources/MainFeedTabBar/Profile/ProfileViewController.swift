//
//  ProfileViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//
import UIKit
import Moya
import BoltsSwift
import Square
import SwiftyBeaver

final class ProfileViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    static func create(editMode: EditMode, otherUserPK: Int? = nil) -> Self {
        let `self` = self.init(editMode: editMode)
        self.title = "Profile"
        self.tabBarItem.image = #imageLiteral(resourceName: "three-24px-black")
        self.otherUserPK = otherUserPK
        return self
    }
    
    required init(editMode: EditMode) {
        self.editMode = editMode
        super.init()
    }
    
    required init() { fatalError("init() has not been implemented") }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    var editMode: EditMode = .off {
        didSet {
            switch editMode {
            case .on: break
            case .off: break
            }
        }
    }
    
    var state: State = .loading {
        didSet {
            managingState()
        }
    }
    
    var provider = MoyaProvider<User>(plugins: [NetworkLoggerPlugin()])
    var postProvider = MoyaProvider<Post>(plugins: [NetworkLoggerPlugin()])
    var otherUserPK: Int?
    lazy var v = ProfileView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
    private func managingState() {
        switch state {
        case .initial:
            initialComposition()
            initialRequest()
            v.profileTableView.reloadData()
        case .loading:
            v.profileTableView.tableFooterView = ViewControllerStateView(state: .loading)
            v.profileTableView.reloadData()
        case .populated:
            v.profileTableView.tableFooterView = nil
            v.profileTableView.reloadData()
        case .retryOnError:
            v.profileTableView.tableFooterView = ViewControllerStateView(state: .retryOnError(owner: self, selector: #selector(retry(_:))))
        }
    }
    
    @objc func retry(_ sender: UIButton) {
        state = .loading
        state = .initial
    }
}

// MARK: initially set up
extension ProfileViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        state = .loading
        state = .initial
    }
    
    private func initialRequest() {
        provider.request(.profile(otherUserPK: otherUserPK)) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    do {
                        let userModel = try response.map(UserModel.self)
                        self.v.initializeProfile(userModel)
                        self.state = .populated(userModel: userModel)
                    }catch {
                        SwiftyBeaver.debug("fail to convert Model: \(#function)")
                        self.state = .retryOnError
                    }
                case false :
                    SwiftyBeaver.debug("fail to Request")
                    self.state = .retryOnError
                }
            case .failure(let error):
                SwiftyBeaver.debug("Server Error: \(error.localizedDescription)")
                self.state = .retryOnError
            }
        }
    }
    
    private func initialComposition() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.transparentNaviBar(true)
    }
}

// MARK: Retry 
extension ProfileViewController {
    @objc func refreshControlAction(_ sender: UIRefreshControl) {
        sender.beginRefreshing()
        viewWillAppear(true)
        sender.endRefreshing()
    }
}

// MARK: UI - Bar Button
extension ProfileViewController {
    @objc func settingBarButtonAction(_ sender: UIBarButtonItem) {
        let settingViewController = SettingViewController()
        let naviVC = UINavigationController(rootViewController: settingViewController)
        present(naviVC, animated: true, completion: nil)
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: Like Action
extension ProfileViewController {
    @discardableResult
    func like(_ postPrivateKey: Int, index: Int) -> BoltsSwift.Task<LikeModel> {
        let taskCompletionSource = TaskCompletionSource<LikeModel>()
        postProvider.request(.like(postPK: postPrivateKey)) { [weak self] (result) in
            guard let self = self, case .populated(let item) = self.state else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode{
                case true :
                    if let likeModel = try? response.map(LikeModel.self) {
                        var copy = item
                        copy.posts[index].modifiedLike(model: likeModel)
                        self.state = .populated(userModel: copy)
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

// MARK: Delete Post Action
extension ProfileViewController {
    func delete(_ postPrivateKey: Int, index: Int) {
        postProvider.request(.delete(postPK: postPrivateKey)) { [weak self] (result) in
            guard let self = self,
                case .populated(let item) = self.state else {
                    return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true :
                    var copy = item
                    copy.posts.remove(at: index)
                    self.state = .populated(userModel: copy)
                    Square.display("Your post has deleted successfully")
                case false:
                    SwiftyBeaver.debug("Request Error")
                    Square.display("Request Error")
                }
                
            case .failure(let error):
                SwiftyBeaver.debug("Server Error: \(error.localizedDescription)")
                self.state = .retryOnError
            }
        }
    }
}

// MARK: TableView Delegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProfileView.UI.tableViewCellHegiht
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .populated(let item) = state, item.posts.count > indexPath.row else {
            return
        }
        let postCover = item.posts[indexPath.row].converted(author: item.author())
        let detailVC = PostDetailViewController.create(
            editMode: otherUserPK != nil ? .off : .on,
            coverData: postCover)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: Edit - TableViwe Delegate
extension ProfileViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return editMode == .on ? true : false
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (rowAction, indexPath) in
            guard let self = self,
                case .populated(let item) = self.state else {
                    return
            }
            
            let post = item.posts[indexPath.row]
            self.delete(post.pk, index: indexPath.row)
        }
        return [deleteAction]
    }
}

// MARK: TableView DataSource - 1
extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .populated(let item) = state else {
            return 0
        }
        return item.posts.count
    }
}

// MARK: TableView Data Source - 2
extension ProfileViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(ProfileCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ProfileCell,
            case .populated(let item) = state else {
                return
        }
        let post = item.posts[indexPath.row].converted(author: item.author())
        cell.configure(model: post) { [weak self] (postPK: Int) -> BoltsSwift.Task<LikeModel> in
            guard let self = self else {
                fatalError()
            }
            return self.like(postPK, index: indexPath.row)
        }
    }
}



