//
//  PostDetailViewController.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya
import BoltsSwift
import Square
import SwiftyBeaver
import Localize_Swift

class PostDetailViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    required init(coverData: PostCoverModel) {
        self.coverData = coverData
        super.init()
    }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    required init() { fatalError("init() has not been implemented") }
    
    static func create(editMode: EditMode = .off,
                       coverData cover: PostCoverModel) -> PostDetailViewController {
        let `self` = self.init(coverData: cover)
        self.editMode = editMode
        return self
    }
    
    var editMode: EditMode = .off {
        didSet {
            switch editMode {
            case .on:
                DispatchQueue.main.async {
                    self.v.toggleView.isHidden = false
                    self.tabBarController?.tabBar.isHidden = true
                }
            case .off:
                DispatchQueue.main.async {
                    self.v.toggleView.isHidden = true
                    self.v.toggleView.layer.opacity = 1.0
                    self.tabBarController?.tabBar.isHidden = true
                }
            }
        }
    }
    
    private var state: State = .loading {
        didSet {
            switch state {
            case .loading: break
            case .ready: DispatchQueue.main.async { self.v.postTableView.reloadData() }
            }
        }
    }
    
    private var toggleState: ToggleView.ToggleType {
        get { return v.toggleView.state }
        set { v.toggleView.state = newValue }
    }
    
    var coverData: PostCoverModel
    private var postPK: Int {
        return coverData.pk
    }
    
    let provider = MoyaProvider<Post>(plugins: [NetworkLoggerPlugin()])
    
    lazy var v = PostDetailView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
}
extension PostDetailViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.activityView.startAnimating()
        requestTask().continueWith { [weak self] task in
            guard let self = self else {
                return
            }
            
            if task.cancelled || task.faulted {
                SwiftyBeaver.error(task.error.debugDescription)
            }else {
                guard let model = task.result else {
                    return
                }
                self.state = .ready(detailModel: model)
                self.v.postTableView.reloadData()
                
            }
            self.v.activityView.stopAnimating()
        }
    }
    
    func requestTask() -> BoltsSwift.Task<PostDetailModel> {
        let taskSource = TaskCompletionSource<PostDetailModel>()
        provider.request(.detail(postPK: postPK)) { result in
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    do {
                        let postDetailData = try response.map(PostDetailModel.self)
                        taskSource.set(result: postDetailData)
                    }catch {
                        taskSource.set(error: NSError(domain: "fail to convert Model: \(#function)", code: 0, userInfo: nil))
                    }
                case false:
                    taskSource.set(error: NSError(domain: "fail to Request: \(#function)", code: 0, userInfo: nil))
                }
            case .failure(let error):
                taskSource.set(error: NSError(domain: error.localizedDescription, code: 0, userInfo: nil))
            }
        }
        return taskSource.task
    }
}
extension PostDetailViewController {
    @objc func authorButtonAction(_ sender: UIButton) {
        let otherUserPK = coverData.author.pk
        if let myPK = KeychainService.pk,
            editMode == .off && otherUserPK != Int(myPK) {
            let profileVC = ProfileViewController.create(editMode: .off, otherUserPK: coverData.author.pk)
            navigationController?.pushViewController(profileVC, animated: true)
        }
    }
}


// MARK: NavigationBar's Items
extension PostDetailViewController {
    @objc func dismissButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func likeButtonAction(_ sender: UIBarButtonItem) {
        v.loadLikeButton()
        provider.request(.like(postPK: coverData.pk)) { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    if let model = try? response.map(LikeModel.self),
                        let liked = model.liked,
                        let numLiked = model.numLiked {
                        self.coverData.liked = liked
                        self.coverData.numLiked = numLiked
                    }
                case false: Square.display("Fail to Request")
                }
                
            case .failure(let error): Square.display("Sever Error: " + error.localizedDescription)
            }
        }
    }
    
    @objc func replyButtonAction(_ sender: UIBarButtonItem) {
        let replyVC = ReplyViewController.create(postPK: coverData.pk)
        present(UINavigationController(rootViewController: replyVC), animated: true, completion: nil)
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func moreButtonAction(_ sender: UIBarButtonItem) {
        Square.display(nil, message: nil,
                       alertActions: [.cancel(message: "Cancel".localized()),
                                      .destructive(message: "Flag as inappropriate".localized())],
                       preferredStyle: .actionSheet) { [weak self] (_, index) in
                        guard let type = MoreButtonType(rawValue: index),
                            let self = self else {
                                return
                        }
                        switch type {
                        case .cancel:
                            break
                        case .report:
                            let vc = UINavigationController(rootViewController: ReportViewController(postPK: self.postPK))
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                        
                        
        }
        
    }
}

// MARK: Edit Buttons
extension PostDetailViewController: PassableDataDelegate {
    @objc func highlightTextButtonAction(_ sender: UIButton) {
        toggleState = .origin
        let vc = UploadTextViewController(textType: .highlight, postPK: postPK)
        show(vc, sender: nil)
    }
    
    @objc func normalTextButtonAction(_ sender: UIButton) {
        toggleState = .origin
        let vc = UploadTextViewController(textType: .basic, postPK: postPK)
        show(vc, sender: nil)
    }
    
    @objc func photoButtonAction(_ sender: UIButton) {
        toggleState = .origin
        let vc = UploadPhotoViewController.create(postPK: postPK)
        vc.delegate = self
        show(vc, sender: nil)
    }
    
    func pass(data: UIImage) {
        // wating..
    }
    
    @objc func toggleViewTapGestureAction(_ sender: UITapGestureRecognizer) {
        toggleState = v.toggleView.state == .spread ? .origin : .origin
    }
}

// MARK: UITableView Delegate
extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard case .ready(let item) = state,
            let contents = item.postContents, contents.count > indexPath.row,
            let contentType = ContentType(rawValue: contents[indexPath.row].contentType) else {
                return 0
        }
        switch contentType {
        case .txt: return UITableView.automaticDimension
        case .img: return UIScreen.mainHeight / 2.2
        }
    }
}

// MARK: for Editing UITableView
// Delete Contents API do not work

extension PostDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let item) = state,
            let contents = item.postContents else {
                return 0
        }
        return contents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case .ready(let item) = state,
            let contents = item.postContents, contents.count > indexPath.row,
            let contentType = ContentType(rawValue: contents[indexPath.row].contentType) else {
                return UITableViewCell()
        }
        
        switch contentType {
        case .txt: return tableView.dequeue(DetailTextCell.self, indexPath: indexPath)
        case .img: return tableView.dequeue(DetailPhotoCell.self, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case .ready(let item) = state,
            let contents = item.postContents, contents.count > indexPath.row,
            let contentType = ContentType(rawValue: contents[indexPath.row].contentType) else {
                return
        }
        
        let content = contents[indexPath.row].content
        switch contentType {
        case .txt:
            guard let cell = cell as? DetailTextCell else {
                return
            }
            cell.configure(content: content)
        case .img:
            guard let cell = cell as? DetailPhotoCell else {
                return
            }
            cell.configure(content: content)
        }
    }
}

