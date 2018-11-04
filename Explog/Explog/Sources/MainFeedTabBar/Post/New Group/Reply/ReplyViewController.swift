//
//  ReplyViewController.swift
//  Explog
//
//  Created by minjuniMac on 04/11/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya
import Square
import BoltsSwift

extension ReplyViewController {
    enum State {
        case loading
        case ready(item: [ReplyModel])
    }
}

final class ReplyViewController: BaseViewController  {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init(postPK: Int) {
        self.postPK = postPK
        super.init()
    }
    
    required init() { fatalError("init() has not been implemented") }
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    static func create(postPK privateKey: Int) -> ReplyViewController {
        let `self` = self.init(postPK: privateKey)
        return self
    }
    
    var postPK: Int
    let provider = MoyaProvider<Reply>(plugins:[NetworkLoggerPlugin()])
    var state: State = .loading {
        didSet {
            switch state {
            case .loading: break
            case .ready: DispatchQueue.main.async { self.v.replyTableView.reloadData() }
            }
        }
    }
    
    lazy var v = ReplyView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    
}

extension ReplyViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(noti:)) ,
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(noti:)) ,
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(noti: NSNotification) {
        guard let notiInfo = noti.userInfo as NSDictionary?,
            let keyboardFrema = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let keyboardDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        
        v.inputContainerViewBottomConstraint.constant = -keyboardFrema.size.height
        UIView.animate(withDuration: keyboardDuration) { self.view.layoutIfNeeded() }
    }
    
    @objc private func keyboardWillHide(noti: NSNotification){
        guard let notiInfo = noti.userInfo as NSDictionary?,
            let keyboardDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return
        }
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
            self.v.inputContainerViewBottomConstraint.constant = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        provider.request(.list(postPK: postPK)) { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let response):
                do {
                    let model = try response.map([ReplyModel].self)
                    strongSelf.state = .ready(item: model)
                }catch {
                    print("fail to convert Model: \(#function)")
                }
                
            case .failure(let error):
                print("Serve Error: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        v.dynamicReload()
    }
}

extension ReplyViewController {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension ReplyViewController {
    @objc func createReplyButtonAction(_ sender: UIButton) {
        guard v.inputTextView.text.count > 0,
            let text = v.inputTextView.text else {
                return
        }
        provider.request(.create(postPK: postPK, comments: text)) { [weak self] result in
            guard let strongSelf = self,
                case .ready(let item) = strongSelf.state else {
                    return
            }
            
            switch result {
            case .success(let response):
                do {
                    var copy = item
                    copy.append(try response.map(ReplyModel.self))
                    strongSelf.state = .ready(item: copy)
                    strongSelf.v.terminationEffect()
                }catch {
                    print("fail to convert Model: \(#function)")
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func delete(reply postPK: Int, indexPath: IndexPath) -> BoltsSwift.Task<Void>{
        let completionSource = TaskCompletionSource<Void>()
        provider.request(.delete(postPK: postPK)) { [weak self] result in
            guard let strongSelf = self,
                case .ready(let item) = strongSelf.state else {
                    return
            }
            switch result {
            case .success:
                var copy = item; copy.remove(at: indexPath.row)
                strongSelf.state = .ready(item: copy)
                completionSource.set(result: ())
            case .failure(let error):
                completionSource.set(error: error)
            }
        }
        return completionSource.task
    }
}

extension ReplyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard case .ready(let item) = state,
            item.count > indexPath.row,
            let author = item[indexPath.row].author,
            let _myPK = KeychainService.pk,
            let myPK = Int(_myPK) else {
                return false
        }
        return myPK == author.pk
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (rowaction, indexPath) in
            guard let strongSelf = self,
                case .ready(let item) = strongSelf.state else {
                    return
            }
            let replyPK = item[indexPath.row].pk
            strongSelf
                .delete(reply: replyPK, indexPath: indexPath)
                .continueWith { _ in
                    strongSelf.v.replyTableView.reloadData()
                    Square.display("Removed Comments")
            }
        }
        return [removeAction]
    }
}

// MARK: TableViewDataSource - 1
extension ReplyViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let item) = state else {
            return 0
        }
        return item.count
    }
}

// MARK: TableViewDataSource - 2
extension ReplyViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard case .ready(let item) = state, item.count > indexPath.row else {
            return UITableViewCell()
        }
        return tableView.dequeue(ReplyCell.self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case .ready(let item) = state, item.count > indexPath.row,
            let cell = cell as? ReplyCell else {
                return
        }
        cell.configure(item[indexPath.row])
        print("indexPath: \(indexPath)")
    }
}

extension ReplyViewController: UITextViewDelegate {
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.textColor = .black
        textView.text = ""
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView.text.count < 100 {
        case true:
            v.uploadState = .enabled
        case false :
            v.uploadState = .unable
            Square.display("Comments can not exceed 100 letters.")
        }
    }
}
