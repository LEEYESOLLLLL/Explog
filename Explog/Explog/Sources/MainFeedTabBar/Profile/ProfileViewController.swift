//
//  ProfileViewController.swift
//  Explog
//
//  Created by minjuniMac on 8/21/18.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

//@objc func logoutButtonAction(_ sender: UIButton) {
//    // temporary..
//    KeychainService.allClear()
//    (parent as? UITabBarController)?.selectedViewController = (parent as? UITabBarController)?.viewControllers?.first!
//    /////////////////////
//}

import UIKit
import Moya


final class ProfileViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    static func create(editMode: EditMode, otherUserPK: Int? = nil) -> Self {
        let `self` = self.init(editMode: editMode)
        self.title = "Profile"
        self.tabBarItem.image = #imageLiteral(resourceName: "profile-32px")
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
            switch state {
            case .loading: break
            case .ready(_ ):
                DispatchQueue.main.async { self.v.profileTableView.reloadData() }
            }
        }
        
    }
    
    var provider = MoyaProvider<User>(plugins: [NetworkLoggerPlugin()])
    var otherUserPK: Int?
    lazy var v = ProfileView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialComposition()
        provider.request(.profile(otherUserPK: otherUserPK)) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    do {
                        let userModel = try response.map(UserModel.self)
                        strongSelf.v.initializeProfile(userModel)
                        strongSelf.state = .ready(item: userModel)
                        
                    }catch {
                        print("fail to convert Model: \(#function)")
                    }
                case false :
                    print("fail to Request: \(#function)")
                }
            case .failure(let error):
                print("Serve Error: \(error.localizedDescription)")
            }
            DispatchQueue.main.async { strongSelf.v.activityIndicator.stopAnimating() }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func initialComposition() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
        navigationController?.transparentNaviBar(true)
        v.activityIndicator.startAnimating()
    }
    
    
    
    @objc func settingBarButtonAction(_ sender: UIBarButtonItem) {
        let settingViewController = SettingViewController()
        let naviVC = UINavigationController(rootViewController: settingViewController)
        present(naviVC, animated: true, completion: nil)
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ProfileView.UI.tableViewCellHegiht
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .ready(let item) = state, item.posts.count > indexPath.row else {
            return
        }
        let postCover = item.posts[indexPath.row].converted(author: item.author())
        let detailVC = PostDetailViewController.create(editMode: otherUserPK != nil ? .off : .on,
                                                       coverData: postCover)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let item) = state else {
            return 0
        }
        return item.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeue(ProfileCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ProfileCell,
            case .ready(let item) = state else {
                return
        }
        let post = item.posts[indexPath.row]
        
        guard let img = post.img else {
            return
        }
        cell.configure(title: post.title,
                       imagePath: img,
                       startDate: post.startDate,
                       endDate: post.endDate,
                       author: item.username,
                       numberOflike: post.numLiked)
    }
}



