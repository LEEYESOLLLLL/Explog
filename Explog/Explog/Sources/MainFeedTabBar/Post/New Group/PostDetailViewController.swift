//
//  PostDetailViewController.swift
//  Explog
//
//  Created by minjuniMac on 26/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya



final class PostDetailViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
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
            case .on:
                // editmode on, editbutton true, navigationItem Button 켜야함..
                DispatchQueue.main.async {
                    self.v.toggleView.isHidden = false
                }
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
            case .ready:
                DispatchQueue.main.async { self.v.postTableView.reloadData() }
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
        // 여기에서 Request후, Model 가지고 있어야함..
        // CoverData, DetailData를 따로 관리해주어야함.
        v.activityView.startAnimating()
        provider.request(.detail(postPK: postPK)) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let response):
                switch (200...299) ~= response.statusCode {
                case true:
                    do {
                        let postDetailData = try response.map(PostDetailModel.self)
                        DispatchQueue.main.async {
                            strongSelf.v.activityView.stopAnimating()
                            strongSelf.state = .ready(detailModel: postDetailData)
                            strongSelf.v.postTableView.reloadData()
                        }
                        
                    }catch {
                        print("fail to convert Model: \(#function)")
                        DispatchQueue.main.async { strongSelf.v.activityView.stopAnimating() }
                    }
                case false:
                    print("fail to Request: \(#function)")
                    DispatchQueue.main.async { strongSelf.v.activityView.stopAnimating() }
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async { strongSelf.v.activityView.stopAnimating() }
            }
        }
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
    // 각 뷰 컨트롤러와 뷰 만들어야함..
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
        return tableView.dequeue(PostDetailTableViewCell.self, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case .ready(let item) = state,
            let cell = cell as? PostDetailTableViewCell,
            let contents = item.postContents, contents.count > indexPath.row else {
                return
        }
        
        guard let contentType = ContentType(rawValue: contents[indexPath.row].contentType) else {
            return
        }
        
        let content = contents[indexPath.row].content
        print("content: \(content.content), photo: \(content.photo)")
        DispatchQueue.main.async {
            cell.configure(contentType: contentType, content: content)
        }
    }
    
}

