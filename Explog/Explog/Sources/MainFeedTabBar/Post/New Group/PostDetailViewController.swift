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

final class PostDetailViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        self.navigationController?.navigationBar.barStyle = .black
        return .lightContent
    }
    init(coverData: PostCoverModel) {
        self.coverData = coverData
        super.init()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    static func create(editMode: EditMode = .off,
                       coverData cover: PostCoverModel) -> PostDetailViewController {
        let `self` = self.init(coverData: cover)
        self.editMode = editMode
        return self
    }
    
    var editMode: EditMode = .off {
        didSet {
            switch editMode {
            case .on: DispatchQueue.main.async { self.v.toggleView.isHidden = false }
            case .off:
                DispatchQueue.main.async {
                    self.v.toggleView.isHidden = true
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
        get {
            return v.toggleView.state
        }set {
            v.toggleView.state = newValue
        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.activityView.startAnimating()
        requestTask().continueWith { [weak self] task in
            guard let strongSelf = self else {
                return
            }
            
            if task.cancelled || task.faulted {
                print(task.error!.localizedDescription)
            }else {
                guard let model = task.result else {
                    return
                }
                strongSelf.state = .ready(detailModel: model)  
                strongSelf.v.postTableView.reloadData()
                
            }
            strongSelf.v.activityView.stopAnimating()
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


// MARK: NavigationBar's Items
extension PostDetailViewController {
    @objc func dismissButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func likeButtonAction(_ sender: UIBarButtonItem) {
        sender.tintColor = sender.tintColor == .red ? .white : .red
    }
    
    @objc func replyButtonAction(_ sender: UIBarButtonItem) {
        
    }
    
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
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
        // request전임.. 여기서 요청하고 화면 내려왔을때
    }
    
    @objc func toggleViewTapGestureAction(_ sender: UITapGestureRecognizer) {
        toggleState = v.toggleView.state == .spread ? .origin : .origin
    }
}

extension PostDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard case .ready(let item) = state,
            let contents = item.postContents, contents.count > indexPath.row,
            let contentType = ContentType(rawValue: contents[indexPath.row].contentType) else {
                return 0
        }
        switch contentType {
        case .txt: return UITableView.automaticDimension
        case .img: return UIScreen.main.bounds.height / 2.2
        }
    }
}

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

