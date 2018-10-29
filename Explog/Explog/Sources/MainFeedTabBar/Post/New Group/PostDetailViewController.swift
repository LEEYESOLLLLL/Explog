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
//                v.editmode(true)
            case .off:
                DispatchQueue.main.async {
                    self.v.toggleView.isHidden = true
                }
                
                // 보니까 UITabBar도 없애야함..
//                v.editmode(false)
            case .ready(let detailModel):
                v.postTableView.reloadData()
            }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 여기에서 Request후, Model 가지고 있어야함..
        // CoverData, DetailData를 따로 관리해주어야함.
        print("postPK: \(postPK)")
        provider.request(.detail(postPK: postPK)) { result in
            switch result {
            case .success(let response):
                
                print(response)
            case .failure(let error):
                print(error.localizedDescription)
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
extension PostDetailViewController {
        @objc func highlightTextButtonAction(_ sender: UIButton) {
            v.toggleView.state = .origin
        }
    
        @objc func normalTextButtonAction(_ sender: UIButton) {
            
        }
    
        @objc func photoButtonAction(_ sender: UIButton) {
            
        }
    
        @objc func toggleViewTapGestureAction(_ sender: UITapGestureRecognizer) {
            v.toggleView.state = v.toggleView.state == .spread ? .origin : .origin
        }
}

extension PostDetailViewController: UITableViewDelegate {
    
}

extension PostDetailViewController: UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 30
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            return tableView.dequeue(PostDetailTableViewCell.self, indexPath: indexPath)
        }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = "\(indexPath.row)"
    }
}


