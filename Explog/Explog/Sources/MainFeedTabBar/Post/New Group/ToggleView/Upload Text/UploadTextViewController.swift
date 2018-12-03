//
//  HighlighteTextViewController.swift
//  Explog
//
//  Created by minjuniMac on 29/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya
import SwiftyBeaver
import Square

extension UploadTextViewController {
    enum TextType: String {
        case basic = "b"
        case highlight = "h"
    }
}

final class UploadTextViewController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    let textType: TextType
    private let postPK: Int
    init(textType: TextType, postPK: Int) {
        self.textType = textType
        self.postPK = postPK
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    required init() { fatalError("init() has not been implemented") }
    
    let provider = MoyaProvider<Post>()//(plugins: [NetworkLoggerPlugin()])
    private var text: String {
        return v.textView.text
    }
    
    lazy var v = UploadTextView(controlBy: self)
    override func loadView() {
        super.loadView()
        view = v
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
}

extension UploadTextViewController {
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func uploadTextButtonAction(_ sender: UIBarButtonItem) {
        guard v.textView.text.count > 0 else {
            return
        }
        provider.request(.text(
            postPK: postPK,
            content: text,
            createdAt: Date().convertedString(),
            type: textType.rawValue)) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let response):
                    switch (200...299) ~= response.statusCode {
                    case true :
                        self.navigationController?.popViewController(animated: true)
                    case false :
                        Square.display("Fail to Request. You need to check Internet Connecting or try again")
                    }
                case .failure(let error):
                    SwiftyBeaver.error("Not Internet Connecting: \(error)")
                }
        }
    }
}
extension UploadTextViewController { 
    @objc func keyboardWillShow(noti: NSNotification) {
        guard let notiInfo = noti.userInfo as NSDictionary?,
            let keyboardFrema = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return
        }
        let height = keyboardFrema.size.height
        v.textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(noti: NSNotification){
        v.textView.contentInset = UIEdgeInsets.zero
        view.layoutIfNeeded()
    }
}

extension UploadTextViewController: UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = .black
    }
}
