//
//  HighlighteTextViewController.swift
//  Explog
//
//  Created by minjuniMac on 29/10/2018.
//  Copyright © 2018 com.dev.minjun. All rights reserved.
//

import UIKit
import Moya

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
    
    let provider = MoyaProvider<Post>(plugins: [NetworkLoggerPlugin()])
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
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .success(let response):
                    switch (200...299) ~= response.statusCode {
                    case true :
                        strongSelf.navigationController?.popViewController(animated: true)
                    case false :
                        print("fail to Request: \(#function)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
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
